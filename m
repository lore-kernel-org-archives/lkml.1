Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZBZUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZBZUCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZBZUCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:02:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:50760 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbZBZUCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:02:33 -0500
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200902261138.34859.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	 <200902261056.05740.david-b@pacbell.net>
	 <20090226190511.GD8595@sirena.org.uk>
	 <200902261138.34859.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 20:02:28 +0000
Message-Id: <1235678548.31223.47.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 11:38 -0800, David Brownell wrote:

> 
> Semi-related:  someone with time to spend on it might
> find and fix the bug causing the regulator framework
> to oops when regulator/core.c::set_machine_constraints()
> returns an error code.

Any chance you can post the oops. Is it happening within the
set_constraints() error path or sometime later on ?  

Thanks

Liam

