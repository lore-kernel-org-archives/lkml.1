Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbXFOLPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbXFOLPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXFOLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:15:45 -0400
Received: from [212.112.238.170] ([212.112.238.170]:55667 "EHLO
	longford.lazybastard.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbXFOLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:15:44 -0400
Date: Fri, 15 Jun 2007 13:10:42 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: LogFS take four
Message-ID: <20070615111041.GA6791@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070615083732.GA20361@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615083732.GA20361@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 June 2007 12:37:32 +0400, Evgeniy Polyakov wrote:
> On Sun, Jun 03, 2007 at 08:38:46PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> > This round the patch is split into file-sized hunks.  There actually
> > seem to be kernel developers not manly enough to digest 6000+ lines of
> > code at once.  An I thought I was the only wimp around.
> > 
> > Again, anyone giving comments in the last round is on Cc:.
> > 
> > I'll try to respond to comments but the next round of patches may take a
> > while longer, due to other responsibilities.
> 
> Hi Jorn.
> 
> Sorry for late reply (and wrong non-utf latter in the name :).

I have been called worse. :)

> I have couple of minor nits I will answer another mails, but in general
> I think it should be included in -mm so that people could start using
> it report real bugs, but not handwaving about possible problems.

Thank you for the confidence.

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
