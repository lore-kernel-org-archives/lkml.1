Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZANRw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZANRw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZANRwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:52:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1071 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZANRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:52:45 -0500
Date: Wed, 14 Jan 2009 17:52:34 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Mike Rapoport <mike@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] mfd: DA9030 USB charge pump mode selection support
Message-ID: <20090114175233.GB8108@sirena.org.uk>
References: <4943FA3E.9090507@cam.ac.uk> <49461CFB.9080108@compulab.co.il> <20081215104730.GA31145@sirena.org.uk> <49465315.2070708@cam.ac.uk> <496E2546.8090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E2546.8090002@gmail.com>
X-Cookie: 1: No code table for op: ++post
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 05:47:50PM +0000, Jonathan Cameron wrote:

> Anyone had a chance to have a look at this?
> I have a board config waiting on this or something with the same
> functionality getting merged.

You probably want to send it to Eric Maio (who wrote the driver
originally) and Samuel Ortiz (MFD maintainer).
