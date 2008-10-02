Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYJBA7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYJBA7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYJBA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:59:26 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:53223 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYJBA7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:59:25 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Jon Masters <jonathan@jonmasters.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <20081001223213.078984344@linutronix.de>
References: <20081001223213.078984344@linutronix.de>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 01 Oct 2008 20:40:14 -0400
Message-Id: <1222908014.31183.67.camel@perihelion.int.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:

> I hope to have a real converted driver (aside of the dummy module used
> for testing) ready real soon - as far as bugs/regressions stay out of
> my way for a while. :)

Sven and I started poking at the various USB host drivers on the flight
back from Plumbers. I'll see if I can convert over a few here on the
systems that I have and send over some patches.

Jon.


