Return-Path: <linux-kernel-owner+w=401wt.eu-S935364AbXEVTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364AbXEVTqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXEVTp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:45:56 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:59157 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbXEVTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:45:55 -0400
Date: Tue, 22 May 2007 21:45:51 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <m3tzu4kjg8.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705222145350.19474@anakin>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
 <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
 <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
 <a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
 <a781481a0705220716l799ee2efm268deefc40993875@mail.gmail.com>
 <m3tzu4kjg8.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Krzysztof Halasa wrote:
> "Satyam Sharma" <satyam.sharma@gmail.com> writes:
> 
> > But of course, John is *bang right* that if /**/ makes gcc do (or not do)
> > _anything at all_ (be it crying out a warning), then someone surely
> > deserves to get his head bashed in ... :-)
> 
> I think it's impossible, comments are removed by preprocessor.

Maybe it's used by some lint-alike tools?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
