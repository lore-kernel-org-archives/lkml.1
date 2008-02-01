Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYBAWjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYBAWjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbYBAWhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:18348 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYBAWhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bt1Y7/7pbRnI1LUZlfHkafReYVA77EaEn3im+833quSKCaF+p9H/ce89Y9a2gkuikCzgwFsmfOug7KlViDeS1pxPwImLylPWppGtEMSMlsT1vtSjvrLatsJirZVKkFVElSHc/oLelCHGI5j1lniRTMHJsvFRV6f3+39SpID7OKw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] ide: make wait_drive_not_busy() static again
Date: Fri, 1 Feb 2008 22:52:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080128221006.GK8767@does.not.exist>
In-Reply-To: <20080128221006.GK8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802012252.29101.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Adrian Bunk wrote:
> After commit 7267c3377443322588cddaf457cf106839a60463 
> wait_drive_not_busy() can become static again.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
