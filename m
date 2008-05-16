Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYEPWcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYEPWcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYEPWcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:32:10 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:56838 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbYEPWcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:32:09 -0400
Date: Sat, 17 May 2008 00:32:06 +0200
From: FD Cami <francois.cami@free.fr>
To: Jo Shields <directhex@apebox.org>
Cc: linux-kernel@vger.kernel.org, legal@narasimha.gpl-violations.org
Subject: Re: GPL Violation: Compro Technology Inc, 2.6.17 modified
 binary-only kernel distribution
Message-ID: <20080517003206.25e90937@olorin>
In-Reply-To: <1210975212.7181.26.camel@mortos>
References: <1210975212.7181.26.camel@mortos>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(adding gpl-violations.org in CC)

--
fdc


On Fri, 16 May 2008 23:00:12 +0100
Jo Shields <directhex@apebox.org> wrote:

> Hi,
> 
> I've discovered a GPL violation by Taiwanese TV card manufacturer Compro
> Technology.
> 
> On their site, they are offering a "driver" for Mandriva
> Linux 2007.1, in the form of an 18 meg "linux.rpm"[1,2,3,4]. This
> "driver" is, in fact, an entire kernel image (from snd-emu10k1.ko to
> libata.ko, with everything in between), generated from Mandriva's kernel
> source package, with local modifications to at least two files (major
> file size gap between Compro and Mandriva kernels in tuner.ko and
> cx88xx.ko).
> 
> Their "driver" is being offered in binary-only form, without any
> accompanying license, and I have received no replies to a formal request
> for source after 2 (Taiwanese) working days. Obviously, this violates
> several GPL clauses, and infringes on the rights of every kernel
> developer with code in 2.6.17.
> 
> It is also the opinion of a LinuxTV developer with whom I've been
> discussing the matter that their modified drivers appear to contain
> large un-redistributable portions of code from a chip vendor's
> proprietary SDK, but we obviously can't adequately check this with
> only .ko files to work with.
> 
> They appear to be offering a similar "driver" for Fedora Core 6, which
> is non-functional, presumably due to a failed upload (cpio fails to
> extract the rpm)[4,5].
> 
> I'm not 100% certain what my next step should be, so I decided this was
> the best place to give a public airing. One suggestion I've had
> suggested is to file a DMCA takedown notice with their (US-based) ISP,
> but I've no idea whether it's the right stage to do something like that,
> nor do I have any claim to any code contained in the kernel. At any
> rate, I wanted to make the kernel developers informed of this discovery.
> 
> I'm not on this mailing list, so a CC: would be appreciated.
> 
> --Jo Shields
> 
> 
> [1] http://www.comprousa.com/downloadfiles/linux.rpm
> [2] http://www.comprousa.com/en/download/sseries.html
> [3] http://www.comprousa.com/en/download/tseries.html
> [4] http://www.comprousa.com/en/download/xseries.html
> [5] http://www.comprousa.com/downloadfiles/kernel-2618prep-3i386.rpm
> 
