Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXCTJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXCTJaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXCTJaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:30:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:17409 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbXCTJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JuKBX/4eXEdu9B3igtqxmcG9mS33l3TWdTPztWVCqRgFUiMbWOOemp7pjIhve1BmtIuJ385oUiUKQg+16AQuOEHtZn76u18VhTCYPIoWq7V6sD35hkj1dJrdkNE1xtMN2VA3YwKssa//dq0/l9KUHezOK1AvKUP09bMiXolbwR8=
Message-ID: <45FFA9C5.1090403@gmail.com>
Date: Tue, 20 Mar 2007 18:30:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tony Vroon <chainsaw@gentoo.org>
CC: Jeff Garzik <jgarzik@pobox.com>, alan@lxorguk.ukuu.org.uk,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22 RESEND] Optional LED trigger for libata
References: <20070320092612.82EF65B80F1@ganymede.vroon.org>
In-Reply-To: <20070320092612.82EF65B80F1@ganymede.vroon.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> This adds an optional wrapper around ata_ac_issue_prot that triggers the LED layer.
> This is used for the PMU LED on G5 towers (IDE trigger). My test platform is a 
> PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
> Now respun as a single patch, and the function name shortened as requested.
> 
> Signed-off-by: Tony Vroon <chainsaw@gentoo.org>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
