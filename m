Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbXEQGNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbXEQGNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXEQGN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:13:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:35862 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXEQGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jWKCo9sve2kYLArWFbpER/F7fMFGi0oenTPpF15UIlEXdfEZ80LrkxIArZ/+AsEkWlXct9J5K4y7i3eB+B+zx9Oje11maShoM0Soql3+EbDvaYigjXa1iWeL1oj4Ol5yUTk0KcdJeuYGa9UJ08xz41u+/2/MHp9y/TD9Asow5aA=
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to
	their respective subdirectories
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <3B9BEEF0-F01D-4FE3-86A8-B58AAAB0B2DC@kernel.crashing.org>
References: <464B78BC.4080900@gmail.com>
	 <3B9BEEF0-F01D-4FE3-86A8-B58AAAB0B2DC@kernel.crashing.org>
Content-Type: text/plain
Date: Thu, 17 May 2007 14:13:14 +0800
Message-Id: <1179382394.28568.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 19:54 -0500, Kumar Gala wrote:
> On May 16, 2007, at 4:33 PM, Antonino A. Daplas wrote:
> 
> > Move arch-specific bits of fb_mmap() to their respective  
> > subdirectories
> >

> You don't need a version in asm-ppc since you have one in asm- 
> powerpc.  We are slowly phasing out arch/ppc in favor of arch/powerpc  
> which merges the 32 and 64-bit support.
> 

Okay, thanks.

Tony

