Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYATEf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYATEf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 23:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYATEfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 23:35:20 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42123 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYATEfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 23:35:19 -0500
Message-ID: <4792CF9A.2030601@davidnewall.com>
Date: Sun, 20 Jan 2008 15:05:38 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matt Mackall <mpm@selenic.com>, Chodorenko Michail <misha@one.by>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org> <1200715842.25782.95.camel@cinder.waste.org> <20080119042750.GA24481@one.firstfloor.org> <1200717635.25782.107.camel@cinder.waste.org> <20080119045415.GA27628@one.firstfloor.org>
In-Reply-To: <20080119045415.GA27628@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I think the misunderstanding on your side is relative to what there
> is less heat. Throttling essentially reduces temporary heat spikes on
> the silicon, but does not make the system overall take less power
> or generate less heat as measured over a longer time because it will
> be idle less.
>   

I don't understand this, and it seems wrong.  Most machines spend most
of their time doing nothing, or as close to nothing as they're allowed. 
Idle, in other words.  Isn't it the case that an idle machine will use
less power when throttled than when not?
