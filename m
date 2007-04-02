Return-Path: <linux-kernel-owner+w=401wt.eu-S933946AbXDBGuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbXDBGuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933947AbXDBGuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:50:08 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:31866 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbXDBGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X0GAUb7W7C94ZdRtb5gwzWaUDm9cN/nldYzST1WsFJu9NwBEzhcSijNMCSDY39vAUJB9SctFrx4uapha9sfyY8e4a0wY1M8SSTKRyLXHRZCfbf3XyxZQw3B2F7IBA7R2rVLfQ7ngI2mJ/reas1XOVrsSNL7ZWfW9Q2pOsy5ouH8=
Subject: Re: [PATCH 1/16] vt-sysfs-for-colors.diff
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:49:55 +0800
Message-Id: <1175496595.4614.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 20:13 +0200, Jan Engelhardt wrote:
> Allow for the palette to be exposed and changed via sysfs. A call to
> /usr/bin/reset will slurp the new definitions in for the current
> console.
> 

I like this. The escape sequences to change the palette does not stay
permanently.

Tony


