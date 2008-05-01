Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbYEAUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbYEAUOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYEAUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:14:23 -0400
Received: from mail.akg-images.de ([217.9.47.161]:35758 "EHLO
	mail.akg-images.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:14:23 -0400
X-Greylist: delayed 2088 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 16:14:22 EDT
Date: Thu, 1 May 2008 21:39:27 +0200
From: Friedrich =?iso-8859-1?Q?G=F6pel?= <f.goepel@akg-images.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501193927.GA27612@butterfingers.in.y0ur.4ss>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:41 Thu 01 May     , Linus Torvalds wrote:
> Same goes for "we should all just spend time looking at each others 
> patches and trying to find bugs in them". That's not a solution, that's a 
> drug-induced dream you're living in.

But is it smarter to discourage people from doing code review, by saying
that they won't be doing it anyway,
or actively and publicly encourage people to do so, even on the chance
that it might not lead to everyone doing it?
It's kind of a self-fulfilling prophecy that way.

Trying to force it through the process is another matter entirely.


Cheers,

Friedrich Göpel
