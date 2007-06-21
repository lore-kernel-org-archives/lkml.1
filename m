Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXFUE1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXFUE1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXFUE0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:26:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbXFUE0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:26:54 -0400
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
	<20070614235004.GA14952@elte.hu>
	<20070615011012.6c09066e@the-village.bc.nu>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 01:26:02 -0300
In-Reply-To: <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 14\:16\:57 -0700 \(PDT\)")
Message-ID: <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, david@lang.hm wrote:

> On Wed, 20 Jun 2007, Alexandre Oliva wrote:
>> Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
>> 
>> On Jun 20, 2007, Andrew McKay <amckay@iders.ca> wrote:
>> 
>>> However, I don't see how this would ever require a company like Tivo
>>> or Mastercard to have their networks play nice with a unit that has
>>> been modified by the end user, potentially opening up some serious
>>> security holes.
>> 
>> Which is why the GPLv3 doesn't make the requirement that you stated.

> so if the BIOS checked the checksum of the boot image and if it found
> it wasn't correct would disable the video input hardware but let you
> boot the system otherwise it would be acceptable to you and the GPLv3?

I don't think so, but IANAL.  What do you think?  Here's what I
think to be the relevant passages.

  [...] The information must suffice to ensure that the continued
  functioning of the modified object code is in no case prevented or
  interfered with solely because modification has been made.

  [...]

  The requirement to provide Installation Information does not include
  a requirement to continue to provide support service, warranty, or
  updates for a work that has been modified or installed by the
  recipient, or for the User Product in which it has been modified or
  installed.  Network access may be denied when the modification
  itself materially and adversely affects the operation of the network
  or violates the rules and protocols for communication across the
  network.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
