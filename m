Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYCSXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYCSXPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933292AbYCSVlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:41:25 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:59406 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937990AbYCSVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:41:23 -0400
Date: Wed, 19 Mar 2008 20:07:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080319190755.GB11432@elte.hu>
References: <patchbomb.1205797011@localhost> <1205918565.4112.61.camel@zakaz.uk.xensource.com> <47E12D39.2000207@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E12D39.2000207@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1573]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I'm actually having problem booting 32-on-64 hvm guests.  Specifically 
> the Fedora installer crashes fairly early on:

is this a bug that has leaked into current upstream -git as well, or is 
it an x86.git/testing issue?

	Ingo
