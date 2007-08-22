Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbXHVOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbXHVOTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbXHVOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:19:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:49867 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbXHVOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l50aCUohvORtmfFa3JlVWucnCXr68HxwuWxoa7cJJGqvDYZIocISp2Se/vRSxEXLSVLPYO22cnoGwvgolUCP62DkyxemgSVSawsZMd5NPnw94KAwTVm6N7MUGeX8QIveAIUCrcK4coi9VMxSJ+JSqgIhr+elv9zxmLFQtcOoo9Q=
Message-ID: <6bffcb0e0708220719j7b07adabl74959c36256df2e@mail.gmail.com>
Date: Wed, 22 Aug 2007 16:19:33 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc3-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
>

allyesconfig

  RELOCS  arch/i386/boot/compressed/vmlinux.relocs
WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c06018f3 02ee1f01   R_386_32 c14adad0  _sdata

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
