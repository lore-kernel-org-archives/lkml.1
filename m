Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbXETNRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbXETNRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXETNRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:17:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:2133 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbXETNRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Sog/Mn1Fuod8O4B7Akh8l9ZlAq4WhtyJNu2IUORJOsDe36LauCEf/m6rIITpeL5cD5uW/E2Ci+xB2QCImVVR9s2SrrSW0+HxjEl4qT1IoTeAhGvNPoiNC8x67/6xfyGxKhv1PZcOfPuu5FYS7K7ZQQsFbPUCVzEciy97Uz52ssE=
Date: Sun, 20 May 2007 15:17:25 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/2] 2.6.22-rc2: known regressions with patches
Message-ID: <20070520131725.GA5775@dreamland.darkstar.lan>
References: <464F74F2.8090207@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F74F2.8090207@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sun, May 20, 2007 at 12:06:42AM +0200, Michal Piotrowski ha scritto: 
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc2
> with patches available.
> 
> Cryptography
> 
> Subject    : cryptomgr oops
> References : http://lkml.org/lkml/2007/5/14/283
> Submitter  : Luca Tettamanti <kronos.it@gmail.com>
> Handled-By : Herbert Xu <herbert@gondor.apana.org.au>
> Patch      : http://lkml.org/lkml/2007/5/19/3
> Status     : patch available

Hello,
I confirm that Herbert's patch fixes the OOPS.


Luca
-- 
Mi piace avere amici rispettabili;
Mi piace essere il peggiore della compagnia.
