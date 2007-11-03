Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbXKCNhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbXKCNhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 09:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXKCNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 09:37:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:51879 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbXKCNhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 09:37:31 -0400
To: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Policy on dual licensing?
References: <slrnfiopoa.9cu.lkml.only@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 03 Nov 2007 14:37:28 +0100
In-Reply-To: <slrnfiopoa.9cu.lkml.only@localhost.localdomain> (Remigiusz Modrzejewski's message of "Sat, 3 Nov 2007 12:14:15 +0000 (UTC)")
Message-ID: <m3fxzno3fr.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remigiusz Modrzejewski <lkml.only@maxnet.org.pl> writes:

> What I propose is implementing a policy on accepting such code.
> According to it, every time a maintainer is considering a driver
> that is derived from BSD and licensed GPL-only, should request
> for dual licensing before accepting the patch. If the submitter is
> reluctant to do so - what can we do, it's better to have this inside
> this way than not at all. However, this should minimize such cases 
> and, hopefully, satisfy the claims about Linux maintainers not doing 
> all that they could to make the world a better place.

It doesn't make sense in general. Being derived from *BSD may mean
only a tiny fragment comes from *BSD. I can't see any valid reason
to force/ask the author to publish his/her code under BSD
(GPL + BSD = BSD) instead of GPLv2 as used by the whole Linux.

There are exceptions, of course - if you take a *BSD project and
include it with no/minor changes it makes sense to use BSD licence,
because we really want to cooperate, and because we don't have to
fear "evil corporations" taking our code (because it's mostly not
"ours").
-- 
Krzysztof Halasa
