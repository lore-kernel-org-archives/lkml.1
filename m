Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYG2Eva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYG2Eva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYG2EvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:51:22 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:36004 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYG2EvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:51:21 -0400
Subject: Re: [malware-list] request for comment: generic kernel interface
	for malware	vendors
From: Jon Masters <jonathan@jonmasters.org>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
In-Reply-To: <20080729033944.GD12085@kroah.com>
References: <1216613887.2960.18.camel@localhost.localdomain>
	 <20080729033944.GD12085@kroah.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 29 Jul 2008 00:50:58 -0400
Message-Id: <1217307058.10237.13.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 20:39 -0700, Greg KH wrote:
> On Mon, Jul 21, 2008 at 12:18:07AM -0400, Eric Paris wrote:
> > 
> > This is a request for comment.  This is a first stab and I'm here to
> > address all of the concerns that people have.  Please don't hold back,
> > I've got thick skin.  BUT, I don't want to hear 'this is how we have
> > been doing it, do it that way.'  I want to hear how this won't work for
> > your needs (and WHY) or how we can do it better.
> > 
> > you can find the patches at:
> > http://people.redhat.com/~eparis/talpa

Ouch. Adds a bunch of hooks outside of LSM - what's the plan here wrt.
LSM, because LKML folks are going to ask :)

Jon.


