Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXFUHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXFUHRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXFUHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:17:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbXFUHRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:17:05 -0400
To: david@lang.hm
Cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
	<20070620175627.319a6c55@the-village.bc.nu>
	<46797C52.4020907@iders.ca>
	<orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
	<ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
	<orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 04:16:11 -0300
In-Reply-To: <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 23\:39\:03 -0700 \(PDT\)")
Message-ID: <ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> no, one of the rules for the network is that the software must be
> certified,

In this case you might have grounds to enforce this restriction of the
network on the network controller itself, I suppose.

Not that you should disable the network controller entirely (this
would render the computer useless for many other purpose unrelated
with blocking connections to your network).

You could instead arrange for the network controller to send some
signal that enables the network to recognize that the device is
running certified software.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
