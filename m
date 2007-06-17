Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXFQEUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXFQEUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 00:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXFQEUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 00:20:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXFQEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 00:20:14 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616233251.GA17270@brong.net>
	<ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706162310.24726.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 01:19:49 -0300
In-Reply-To: <200706162310.24726.dhazelton@enter.net> (Daniel Hazelton's message of "Sat\, 16 Jun 2007 23\:10\:24 -0400")
Message-ID: <orejkbkyai.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Saturday 16 June 2007 21:54:56 Alexandre Oliva wrote:

>> There may be laws that require certification or limitations on the
>> user.  Manufacturer giving up the ability to make modifications would
>> address this, or *perhaps* arranging for user and manufacturer to each
>> hold half of the key needed to run a modification (which might comply
>> with the GPLv3dd4 terms, IANAL).

> It doesn't. The GPLv3 (dd4) makes that very clear. See the quote below.

You left out the relevant bit:

  this requirement does not apply if neither you nor any third party
  retains the ability to install modified object code on the User
  Product (for example, the work has been installed in ROM).

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
