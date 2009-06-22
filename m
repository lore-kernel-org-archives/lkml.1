Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZFVV0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZFVV0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZFVV0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:26:47 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:44146 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZFVV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:26:46 -0400
Subject: Re: [PATCH 1/1] hwlat_detector: A system hardware latency detector
From: Jon Masters <jonathan@jonmasters.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090622142014.2a1e675b.akpm@linux-foundation.org>
References: <20090611045829.714510042@jonmasters.org>
	 <20090611045939.103213179@jonmasters.org>
	 <20090622121736.588ae743.akpm@linux-foundation.org>
	 <1245704283.15044.28.camel@localhost.localdomain>
	 <20090622142014.2a1e675b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 22 Jun 2009 17:26:50 -0400
Message-Id: <1245706010.15044.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 14:20 -0700, Andrew Morton wrote:
> On Mon, 22 Jun 2009 16:58:03 -0400
> Jon Masters <jonathan@jonmasters.org> wrote:

> > So...I'll post another update (thanks again). Am I certainly too late
> > for this merge window? That's ok too.
> 
> We're generally pretty relaxed about merging updates to just-added
> subsystems.  There's not much point in releasing them in a
> known-to-be-unfinished form.  And if a late fix _does_ break the
> driver, that still isn't strictly a regression against the previous
> kernel release.

Ok, so there's my carrot...I'll go find the stick and beat myself until
it's done. Thanks again, Andrew.

Jon.


