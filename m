Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYFLEXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYFLEXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYFLEXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:23:24 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:51751 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750869AbYFLEXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:23:23 -0400
Date: Thu, 12 Jun 2008 01:23:20 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080612042320.GB19980@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <20080609001540.GA19072@ime.usp.br> <20080611093605.GA13557@ime.usp.br> <200806112021.50264.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806112021.50264.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: bd4a39355d6616f277757223479cc646
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo.

On Jun 11 2008, Ivo van Doorn wrote:
> Hi,
> 
> > Oh, these endianness problems are a headache. I just fixed some in one
> > small program in lame (the MP3 compressor), but in the end, I finally
> > won. :-)

Just for the record, it is an ABX tool that I'm refactoring so that you
can compare two songs (one original and one compressed) and choose (from
a randomly chosen one) which is the original track. You might be
surprised at how LAME works well with even very low bitrates.

The program wasn't working with big-endian arches, but I fixed that
yesterday. :-)

> > Anyway, did you have some time to check your D-Link stick? I am
> > willing to test more things or other kernel trees, if that is
> > helpful to the project.
> 
> Kernel is compiling right now,

Nice. Thank you.

> I did attempt to test this earlier, but something has changed in the
> IDE/SATA drivers or something because I 2.6.26 no longer recognized my
> hard disk during boot which obviously makes booting quite
> complicated. ;)

Obviously. :-) I'm waiting to get rid of MacOS X from this iBook. I
still want it to be with me for quite some time.


Thank you very much, Rogério.

P.S.: If you want me to test anything else, like a git tree or
something, please, don't hesitate to ask. I want the driver to work for
me (of course) and to have it work better for all the people with ra
wireless chips.
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
