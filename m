Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0BVQfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:35:08 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:35142 "HELO
	outboundproxy6.bluehost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751893Ab0BVQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:35:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HxD753s1by7iZBa5a5Jfbt2eJbS/5Tv8L9S5JF1Hgmw/gZaCM3o9Kjto/t2EhzBd3q5+20PHkS/nMXOkGbLTBBD7mZx5oSb2oqzNVL1JwLowglyUUxSPo2FE374BDP9f;
Date: Mon, 22 Feb 2010 08:32:36 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pedro Ribeiro <pedrib@gmail.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] i915 / PM: Fix hibernate regression caused by
 suspend/resume splitting
Message-ID: <20100222083236.45bf150d@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1002220746260.4141@localhost.localdomain>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
	<201002172320.57491.rjw@sisk.pl>
	<74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
	<201002182306.28052.rjw@sisk.pl>
	<alpine.LFD.2.00.1002220746260.4141@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 07:47:53 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Jesse, Eric, what's the status of this patch? 
> 
> Should I take it directly (I'd really like an Ack) or is it queued up in 
> some tree waiting for me to pull? Or is there some reason not to have it, 
> despite it fixing things for some people?

Hm, I thought Eric had applied that to his for-linus branch, but it
looks like that branch is empty now.  Maybe Rafael posted an update
that Eric missed and so you just have a partial fix in your tree?

-- 
Jesse Barnes, Intel Open Source Technology Center
