Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbXFZTox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbXFZTox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXFZToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:44:46 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:59972 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757289AbXFZTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:44:45 -0400
To: david@lang.hm
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <200706172319.22381.a1426z@gawab.com>
	<200706260717.19677.a1426z@gawab.com>
	<orzm2n44s8.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706261344.23906.a1426z@gawab.com>
	<or8xa64p4h.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706261013230.23285@asgard.lang.hm>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 26 Jun 2007 16:44:13 -0300
In-Reply-To: <Pine.LNX.4.64.0706261013230.23285@asgard.lang.hm> (david@lang.hm's message of "Tue\, 26 Jun 2007 10\:17\:23 -0700 \(PDT\)")
Message-ID: <orr6ny33hu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, david@lang.hm wrote:

> unless you are saying that the GPLv3 is saying that a third party link
> now _is_ sufficiant.

Yup.  The improvement in GPLv3 is to relax the requirement of
providing source code in physical medium if you choose to not
distribute it along with the binaries.  It's recognizing that internet
access is no longer a barrier that could stop someone from obtaining
the sources they're entitled to.  Even someone who doesn't have
regular or fast internet access can hire a third party who does to
perform the download and record it.

I.e., with GPLv3, you *can* point at the sources you used, even in a
site that you don't control.

However, if the site takes the sources out, you're still responsible
for providing sources to those who received the sources from you from
that point on.  Or something like that, IANAL ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
