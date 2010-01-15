Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0AOQPe (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307Ab0AOQPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:15:33 -0500
Received: from www17.your-server.de ([213.133.104.17]:52503 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0AOQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:15:32 -0500
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
From: Thomas Meyer <thomas@m3y3r.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon>  <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipti  <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 17:14:40 +0100
Message-ID: <1263572080.2217.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 15.01.2010, 10:54 +0200 schrieb Pekka Enberg:

> So, any suggestions how I should proceed with figuring out the
> "flashing" problem I still see with Jesse's patch? I can do a full git
> bisect if it comes to that but it's going to be bit difficult to
> determine if a commit is good or bad as there seem to be _two_
> different problems both of which cause screen flickering.
> 
> Heelp!

Does it look like the video in this bug, see attached video in the bug
report:

http://bugzilla.kernel.org/show_bug.cgi?id=14670

greets
thomas


