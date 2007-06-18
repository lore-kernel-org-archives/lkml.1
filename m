Return-Path: <linux-kernel-owner+w=401wt.eu-S1765537AbXFRTpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765537AbXFRTpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763256AbXFRTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:44:57 -0400
Received: from www.osadl.org ([213.239.205.134]:38364 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763046AbXFRTo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:44:56 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Mon, 18 Jun 2007 21:44:06 +0200
User-Agent: KMail/1.9.5
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
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706180922.26630.hjk@linutronix.de> <orwsy1ay8m.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orwsy1ay8m.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706182144.06825.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 18 Juni 2007 20:55 schrieb Alexandre Oliva:
> On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> 
> > So, if a manufacturer used a ROM instead of a flash memory with the
> > intention to make software modifications impossible, then it is bad,
> > and when he did it for economical reasons, then it is a "natural barrier"?
> 
> This sounds about right to me.
> 
> Intent is very significant, but then, what vendor would justify the
> choice of ROM as "intent to prevent modifications", if this amounted
> to copyright infringement?

Indeed. That nicely shows how useless any licensing discussion is
when it comes to hardware design issues, including "Tivoization". 

> 
> Vendor would be entitled to the benefit of the doubt as to the
> motivations in this case, so it would likely be unenforceable anyway.
>

Right. If GPL v3 comes out, there'll probably be a new task for
hardware development engineers: How to find excuses for hardware that
prevents software modifications and how to conceal the true intent.

Hans
 
