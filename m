Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964Ab0ARR4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0ARR4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881Ab0ARR4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:56:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57542 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752986Ab0ARR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:56:45 -0500
Date: Mon, 18 Jan 2010 17:56:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
Message-ID: <20100118175642.GA12760@rakim.wolfsonmicro.main>
References: <1263830523.3632.22.camel@realization>
 <20100118163212.GA32045@rakim.wolfsonmicro.main>
 <1263834473.3632.31.camel@realization>
 <20100118172002.GB6889@rakim.wolfsonmicro.main>
 <1263837004.3632.52.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263837004.3632.52.camel@realization>
X-Cookie: Love IS what it's cracked up to be.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:50:04PM +0100, Alberto Panizzo wrote:

> Maybe I not deep explained what's going on..

Like I say, half the problem was that the first bit of code was very
opaque so by the time you got past that the reader was already likely to
be lost.
