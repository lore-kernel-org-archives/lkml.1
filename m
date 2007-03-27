Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXC0EwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXC0EwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXC0EwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:52:25 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53538 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792AbXC0EwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:52:24 -0400
Date: Tue, 27 Mar 2007 13:49:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
Message-ID: <20070327044914.GA26099@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	"Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1174903941.32691.72.camel@roc-desktop> <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop> <20070327035734.GA25883@linux-sh.org> <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 12:34:25AM -0400, Mike Frysinger wrote:
> On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> >You should really consider the latter for getting updates merged in the 
> >future
> 
> we're planning for this, but the short term it isnt doable for us
> 
If you think mangling patches by hand is a more effective use of time, no
one is stopping you -- some people even prefer that. On the other hand, if
you're struggling with an effective methodology before things are merged,
what reason is there to suspect that things will get better afterwards?
Going by Bryan's post, it's clear that the current system isn't working
for you at least.
