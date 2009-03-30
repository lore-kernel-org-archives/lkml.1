Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZC3JxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZC3JxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZC3Jwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:52:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42283 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbZC3Jwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:52:50 -0400
Date: Mon, 30 Mar 2009 10:52:45 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Liam Girdwood <lrg@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: regulator: Add disable_on_boot flag to constraints.
Message-ID: <20090330095245.GB31781@sirena.org.uk>
References: <4975BE69.5040106@cam.ac.uk> <20090120124338.GA31521@sirena.org.uk> <4975CAF5.9090607@cam.ac.uk> <4975CF70.5080802@gmail.com> <1232482483.16911.299.camel@vega.slimlogic.co.uk> <497734D3.4090207@cam.ac.uk> <49CFCB44.1080608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CFCB44.1080608@gmail.com>
X-Cookie: Dead? No excuse for laying off work.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 07:25:56PM +0000, Jonathan Cameron wrote:

> Any more comments / requested changes?

> If anyone wants this rebased against a current tree just ask.
> ( I don't think it ended up in any relevant trees.  Sorry if I've just
> missed it!)

I'm happy with it but it does need redoing against the current regulator
branch.  Might be worth renaming the option to disable_immediately or
something, though.
