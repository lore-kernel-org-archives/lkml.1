Return-Path: <linux-kernel-owner+w=401wt.eu-S1764168AbYASEvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764168AbYASEvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbYASEuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:50:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37116 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbYASEux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:50:53 -0500
Date: Sat, 19 Jan 2008 05:54:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chodorenko Michail <misha@one.by>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080119045415.GA27628@one.firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org> <1200715842.25782.95.camel@cinder.waste.org> <20080119042750.GA24481@one.firstfloor.org> <1200717635.25782.107.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200717635.25782.107.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It will relative to not throttling.

No it will not. Please reread Dominik's mail I linked to. It explains 
it clearly.

> You made a claim that is -physically impossible- as stated, a claim I've
> seen here before and I'm correcting it. If something reduces heat, it
> must save power *by the definition of heat and power*. And if you reduce
> power usage, you will make your battery last longer.

I think the misunderstanding on your side is relative to what there
is less heat. Throttling essentially reduces temporary heat spikes on
the silicon, but does not make the system overall take less power
or generate less heat as measured over a longer time because it will
be idle less.

-Andi
