Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYAYKUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYAYKUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYAYKT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:19:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:45673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYAYKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:19:57 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Date: Fri, 25 Jan 2008 11:19:52 +0100
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <C3BF59DD.1B68F%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C3BF59DD.1B68F%Keir.Fraser@cl.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251119.52798.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Whether this a problem in light of Xen spurious faults depends on whether
> NMI handlers touch dynamically-allocated data.

How do you define dynamically-allocated data?

-Andi
