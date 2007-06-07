Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbXFGOP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbXFGOP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXFGOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:15:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:11138 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXFGOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FTZ00NElrhSkE0gex3snIu6DKK7mteZ4rCaxsqGiN7TZoN1m+/+jcbzsGorFXgLsrdiNOOhWTd+qKo7hGFUBEVZugfaONbOe61AjZMJc2ysEIifdKrUupojEDVCycqLFHVv+BusDJT0Cvbv19lUurWsjP14IM1n0n9svgrJHOR0=
Subject: Re: [PATCH] radeonfb: Add ID for Radeon Xpress 1100
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Yen Rui <ruiyen@gmail.com>
Cc: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <a0b3dd8d0706070700i3b029c28h7c6c6d3f6569fe16@mail.gmail.com>
References: <a0b3dd8d0706070700i3b029c28h7c6c6d3f6569fe16@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 22:15:06 +0800
Message-Id: <1181225706.4502.23.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 00:00 +1000, Yen Rui wrote:
> Hi,
> 
> I have to attach the patch instead of inlining it in this e-mail
> because gmail converts word wraps into hard returns.  Sorry.
> 

A similar patch is already in the -mm tree.

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/broken-out/radeonfb-add-support-for-radeon-xpress-200m-rs485.patch

Tony

