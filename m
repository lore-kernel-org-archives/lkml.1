Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbXIRRyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbXIRRyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXIRRxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:53:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55131 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbXIRRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:53:50 -0400
Date: Tue, 18 Sep 2007 19:55:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Philipp Marek <philipp@marek.priv.at>, linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-ID: <20070918175513.GD26539@uranus.ravnborg.org>
References: <200709181714.34035@x5> <20070918171313.GA6591@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918171313.GA6591@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 01:13:13PM -0400, Jeff Dike wrote:
> On Tue, Sep 18, 2007 at 05:14:33PM +0200, Philipp Marek wrote:
> > I'm trying to build a UML machine on x86-64 (config attached) 
> > but I'm getting compile errors.
> 
> Builds for me.  Did you start with an mrproper?  These errors look
> like the UML build getting confused by left-overs from an x86_64
> build.
Sounds to me like a known issue by you. Can you give a few more details
so we maybe can get it fixed?

	Sam
