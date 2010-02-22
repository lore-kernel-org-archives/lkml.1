Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0BVPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:48:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab0BVPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:48:28 -0500
Date: Mon, 22 Feb 2010 07:47:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pedro Ribeiro <pedrib@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] i915 / PM: Fix hibernate regression caused by suspend/resume
 splitting
In-Reply-To: <201002182306.28052.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1002220746260.4141@localhost.localdomain>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com> <201002172320.57491.rjw@sisk.pl> <74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com> <201002182306.28052.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jesse, Eric, what's the status of this patch? 

Should I take it directly (I'd really like an Ack) or is it queued up in 
some tree waiting for me to pull? Or is there some reason not to have it, 
despite it fixing things for some people?

		Linus
