Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYFJTQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYFJTQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbYFJTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:15:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:26439 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYFJTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cIuQwgKYZvA8lIdK0fyiFiDah9Ofd39hHKsivJJrNx7fk76DEhkPlP2HZXtLxLfA4/
         JaiAX80lIfl6vIiA2XISLoc/Qo9rXZ4oDxFyFTHDT98jEGF0rShkHvm+ypFUTBGMWOck
         x7cQ1bMPAXtYjdEre2uPU0DK3ET+1nWfNMX+w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] export ide_doubler
Date: Tue, 10 Jun 2008 19:49:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080609222207.GC1987@cs181133002.pp.htv.fi>
In-Reply-To: <20080609222207.GC1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101949.33005.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008, Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   Building modules, stage 2.
>   MODPOST 1204 modules
> ERROR: "ide_doubler" [drivers/ide/ide-core.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
