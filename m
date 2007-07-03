Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXGCWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXGCWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXGCWgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:36:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbXGCWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:36:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 00:43:32 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707032332.49694.rjw@sisk.pl> <1183498555.3388.14.camel@localhost.localdomain>
In-Reply-To: <1183498555.3388.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707040043.32995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 23:35, Benjamin Herrenschmidt wrote:
> On Tue, 2007-07-03 at 23:32 +0200, Rafael J. Wysocki wrote:
> > 
> > Still, do you really think that we're ready to drop it _right_ _now_
> > (I'm
> > referring to suspend only) and if so than on what basis (except that
> > you
> > don't like it, which falls short of being a techical argument)?
> 
> Works fine for me without it ;-)

Yeah, that makes sense. ;-)

Still, someone needs to take care of bug reports from unlucky people and I
wouldn't like to increase the number of these by doing such a high-level change
without any preparations ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
