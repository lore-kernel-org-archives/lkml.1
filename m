Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbXFOWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbXFOWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbXFOWkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:40:46 -0400
Received: from khc.piap.pl ([195.187.100.11]:33427 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbXFOWkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:40:45 -0400
To: David Greaves <david@dgreaves.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Michael Gerdau <mgd@technosis.de>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142049.41819.dhazelton@enter.net>
	<200706150825.15491.mgd@technosis.de>
	<200706150520.15086.dhazelton@enter.net>
	<46726793.1020206@dgreaves.com>
	<alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
	<4672D648.7020700@dgreaves.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 16 Jun 2007 00:40:42 +0200
In-Reply-To: <4672D648.7020700@dgreaves.com> (David Greaves's message of "Fri, 15 Jun 2007 19:11:20 +0100")
Message-ID: <m37iq496z9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves <david@dgreaves.com> writes:

> This 5 minute design undoubtedly has flaws but it shows a direction:
> A basically standard 'De11' PC with some flash.
> A Tivoised boot system so only signed kernels boot.
> A modified kernel that only runs (FOSS) executables whose signed hash
> lives in the flash.

How hard would it be to reprogramm the flash?
-- 
Krzysztof Halasa
