Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZDVI1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZDVI1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZDVI0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:26:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51164 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbZDVI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:26:45 -0400
Date: Wed, 22 Apr 2009 09:26:43 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090422082643.GA10356@sirena.org.uk>
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main> <49EDB569.2060701@compulab.co.il> <20090421125528.GD25828@sirena.org.uk> <49EDD02B.5020407@compulab.co.il> <20090421135640.GE25828@sirena.org.uk> <49EDD1C9.2060408@compulab.co.il> <20090421141408.GF25828@sirena.org.uk> <49EECDF1.9010706@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EECDF1.9010706@compulab.co.il>
X-Cookie: All's well that ends.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:57:37AM +0300, Mike Rapoport wrote:

> What about "line-supply"?

In power management line normally refers to the core, unregulated power
bus for the system and a line supply would normally be something like a
wall wart that supplies this directly when it's connected.
