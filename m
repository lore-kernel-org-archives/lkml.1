Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZDUN4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZDUN4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZDUN4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:56:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43487 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDUN4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:56:41 -0400
Date: Tue, 21 Apr 2009 14:56:40 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090421135640.GE25828@sirena.org.uk>
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main> <49EDB569.2060701@compulab.co.il> <20090421125528.GD25828@sirena.org.uk> <49EDD02B.5020407@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDD02B.5020407@compulab.co.il>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 04:54:51PM +0300, Mike Rapoport wrote:
> Mark Brown wrote:
> > On Tue, Apr 21, 2009 at 03:00:41PM +0300, Mike Rapoport wrote:

> >> I've managed to create some preliminary "line-consumer" driver. I don't really
> >> like the name, but I couldn't think of something better and "virtual" is
> >> already taken :)

> > "userspace" or "user"?  The goal here is to let userspace applications
> > be consumers.

> I don't quite understand your intention here. Do you mean that it would bebetter
> to use a character device rather than sysfs?

I'm talking about the name.
