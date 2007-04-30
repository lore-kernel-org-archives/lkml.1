Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXD3WlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXD3WlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXD3WlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:41:09 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:46258 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422813AbXD3WlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:41:06 -0400
Date: Mon, 30 Apr 2007 15:41:03 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: hermann-pitton@arcor.de, Michael Krufky <mkrufky@linuxtv.org>,
       akpm@linux-foundation.org, Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       mrechberger@gmail.com
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
In-Reply-To: <alpine.LFD.0.98.0704300854090.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0704301458460.315@shell2.speakeasy.net>
References: <20070429182209.267430@gmx.net> 
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org> 
 <20070429205925.129920@gmx.net>  <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
  <20070429230037.95120@gmx.net>  <1177894713.3046.5.camel@p
 <alpine.LFD.0.98.0704300854090.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Linus Torvalds wrote:
> Anyway, I'll get out of the discussion. There's clearly some personality
> issues in the DVB area, and I don't know quite _why_ that is, but Uwe,
> you're definitely not helping.

There isn't a problem here, just a lot of noise coming from one source.  I
have no problem with Mauro and think he does a good job and is an extremely
reasonable person.  He is just getting Uwe's thesaurus thrown at him
because he's the closest target.

Sure there are disagreements sometimes, but this is always the case.  I can
think of plenty of lists far more full of flames and personality conflicts
than linux-dvb.

The issue with dst is just a minor missing feature to fully support the dvb
helper module customization system.  So nobody needs to worry about this
anymore, the last two patches in this repository will fix it correctly.

http://linuxtv.org/hg/~tap/dst-new?cmd=summary;style=gitweb

Making dvb-pll work fully with this same system is a little more complex.
It's on the virtual todo list, but not at the top.

I'll finish with this completely unrelated quote.

------------
   "Especially important is the warning to avoid conversations with the demon.
   We may ask what is relevant but anything beyond that is dangerous.  He is a
   liar.  The demon is a liar.  He will lie to confuse us.  But he will also
   mix lies with the truth to attack us.  The attack is psychological, Damien,
   and powerful.  So don't listen to him.  Remember that - do not listen."
    - from "The Exorcist"
