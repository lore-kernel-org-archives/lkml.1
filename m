Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYAXWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYAXWU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYAXWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:20:16 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:36423 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbYAXWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:20:14 -0500
Subject: Re: [patch 01/26] Linux Kernel Markers Support for Proprierary
	Modules
From: Jon Masters <jonathan@jonmasters.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080124203332.749619937@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
	 <20080124203332.749619937@polymtl.ca>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 24 Jan 2008 17:19:20 -0500
Message-Id: <1201213160.25284.163.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 15:27 -0500, Mathieu Desnoyers wrote:

> There seems to be good arguments for markers to support proprierary modules. So
> I am throwing this one-liner in and let's see how people react. It only makes
> sure that a module that has been "forced" to be loaded won't have its markers
> used. It is important to leave this check to make sure the kernel does not crash
> by expecting the markers part of the struct module by mistake in the case there
> is an incorrect checksum.

Acked-by: Jon Masters <jcm@jonmasters.org>


