Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXFYOos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXFYOos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbXFYOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:44:40 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:45668 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbXFYOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:44:40 -0400
Date: Mon, 25 Jun 2007 10:44:39 -0400
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625144439.GI10008@csclub.uwaterloo.ca>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 07:51:38PM +0200, Tomasz K?oczko wrote:
> 
> Few dayas ago OSS source code was oppened uder CDDL for Solaris and GLPv2 
> for Linux:
> 
> http://www.opensound.com/press/2007/oss-gpl-cddl.txt
> 
> So this source without problems code can be integragrated in Linus tree 
> and after this Linux can provide much better soud supoport than 
> with current ALSA.
> 
> Any plans for doing this ?

In my experience OSS is a pile of crap compared to ALSA.  The only thing
it has ever had was support for sound chips that requried an NDA to get
the specs.

Keep alsa, but possibly add support to alsa for whichever devices are
missing support.

--
Len Sorensen
