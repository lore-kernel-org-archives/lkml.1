Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYBJBbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYBJBbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 20:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYBJBaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 20:30:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2067 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756222AbYBJBay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 20:30:54 -0500
Date: Sun, 10 Feb 2008 01:30:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jon Masters <jonathan@jonmasters.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Al Boldi <a1426z@gawab.com>, Zan Lynx <zlynx@acm.org>
Subject: Re: [sample] mem_notify v6: usage example
Message-ID: <20080210013047.GB4618@ucw.cz>
References: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com> <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-09 11:07:09, Jon Masters wrote:
> This really needs to be triggered via a generic kernel 
> event in the  final version - I picture glibc having a 
> reservation API and having  generic support for freeing 
> such reservations.

Not sure what you are talking about. This seems very right to me.

We want memory-low notification, not yet another generic communication
mechanism.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
