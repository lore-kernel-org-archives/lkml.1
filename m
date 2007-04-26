Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbXDZUqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbXDZUqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXDZUqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:46:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041AbXDZUqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:46:02 -0400
Date: Thu, 26 Apr 2007 13:45:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177618081.4737.42.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0704261343150.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <1177607026.30284.197.camel@frg-rhel40-em64t-04> 
 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
 <1177618081.4737.42.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> 
> Perhaps you should try to make an alternative yourself instead of
> pushing us into making something we don't believe will work (my case) or
> have already done but in a way you don't like (Rafael). Don't talk about
> Pavel cutting code. He's just acking/nacking what Rafael sends him.

I've done that in the past (USB, PCMCIA - screw the maintainers, redo 
it basically from scratch). But the thing is, I'm totally uninterested 
personally in the whole disk-snapshotting, so I'm not likely to do it 
there.

But yes, I'm actually hoping that some new person will come in with a new 
idea. The current people seem to be too set in "their" corners, and I 
don't expect that to really change.

Quite honestly, I don't foresee any of the current tree approaches really 
doing something new and obviously better, unless somebody new steps in.

			Linus
