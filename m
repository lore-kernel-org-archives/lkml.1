Return-Path: <linux-kernel-owner+w=401wt.eu-S1765829AbXFRS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765829AbXFRS6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764639AbXFRS6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:58:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763832AbXFRS6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:58:05 -0400
To: =?utf-8?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: mea culpa on the meaning of Tivoization
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618005041.6c51a368@the-village.bc.nu>
	<orabuydqs8.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706180922.26630.hjk@linutronix.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 15:55:37 -0300
In-Reply-To: <200706180922.26630.hjk@linutronix.de> (=?utf-8?Q?=22Hans-J?=
 =?utf-8?Q?=C3=BCrgen?= Koch"'s message of "Mon\, 18 Jun 2007 09\:22\:26
 +0200")
Message-ID: <orwsy1ay8m.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> So, if a manufacturer used a ROM instead of a flash memory with the
> intention to make software modifications impossible, then it is bad,
> and when he did it for economical reasons, then it is a "natural barrier"?

This sounds about right to me.

Intent is very significant, but then, what vendor would justify the
choice of ROM as "intent to prevent modifications", if this amounted
to copyright infringement?

Vendor would be entitled to the benefit of the doubt as to the
motivations in this case, so it would likely be unenforceable anyway.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
