Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbXIMPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbXIMPqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbXIMPqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:46:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:29179 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXIMPqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=caWu70mhNWSw4wxVEGPGHX23Kd+myZEpze+PknBMgwXxm5caSczV16YWOotUlOL3Skw1UY2sDPjTc+UOkEtlvG2YaX6Mp2kC7uG/Wq1GBWN5bW07YZ4ej3FOH23rc7blUbVReEByb+HRTHYseREemT+QiGk8lBo+NBM2+2eYKtA=
Message-ID: <9a8748490709130846n4074b295r4893bef259734c9e@mail.gmail.com>
Date: Thu, 13 Sep 2007 17:46:00 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-kernel]how to get the latest kernel source tree?
Cc: "Frank Liu" <frank.liu64@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0709130541t364e5b83q48d4711347c7fd0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f405816b0709130534k11fc5ca0r4f9ac1f0ea9725e@mail.gmail.com>
	 <f405816b0709130537u2e038053tca1a96f6711952f8@mail.gmail.com>
	 <6bffcb0e0709130541t364e5b83q48d4711347c7fd0b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/2007, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Frank,
>
> On 13/09/2007, Frank Liu <frank.liu64@gmail.com> wrote:
> > For some reason I was not able to use git, but I still wanna get the
> > latest kernel source tree as I hope to submit a patch, hence I am now
> > about to do the things like this:
> >
> > -download kernel 2.6.22.6 as this is the latest stable version
> > -and download patch-2.6.23-rc6.bz2 and decompressed it
>
> This patch is against 2.6.22, not 2.6.22.6
>
It's all explained in Documentation/applying-patches.txt btw.
http://lxr.linux.no/source/Documentation/applying-patches.txt

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
