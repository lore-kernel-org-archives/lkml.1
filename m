Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbYDPFn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbYDPFn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYDPFnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:43:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:14719 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYDPFnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Ec5VOAICmUyngJTP+ds6ErbgCUCEJDeNTtQKVPOZzBH75gBa3OegdC0rN9FG9IqRJOOdARwClfC93hK99FqUUZBhi0njCIYtJkkjRsS2B7rapJVX8EC4fJJ+0IHB7uSDpMMM/heiold7M5mkdMYSMmfcFQ+kBO6oHuTeltmGNOI=
Date: Wed, 16 Apr 2008 13:39:19 +0800 (CST)
Message-Id: <20080416.133919.133424295.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Clean up arch/um/drivers/ubd_kern.c
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080415133325.GA7882@c2.user-mode-linux.org>
References: <20080413.005559.143852921.xiyou.wangcong@gmail.com>
	<20080414234237.48ac4609.akpm@linux-foundation.org>
	<20080415133325.GA7882@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 15 Apr 2008 09:33:25 -0400
> On Mon, Apr 14, 2008 at 11:42:37PM -0700, Andrew Morton wrote:
> > omg, when checkpatch bit into this patch my CPU melted.
> 
> Yeah, I've been scared to do a checkpatch run over that file.  I think
> it's the only core file left in UML which hasn't been tidied.  Sorry.

Oh, I thought I have checked all the patch with checkpatch.pl, it seems
that this one was missing. Sorry. ;(

> 
> Drop this one, and I'll send a another one which at least is tidied up
> around the changed areas.
> 

Please feel free to do that.

