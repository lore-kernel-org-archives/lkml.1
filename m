Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYBOR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYBOR3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYBOR3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:29:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37027 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYBOR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:29:11 -0500
Date: Fri, 15 Feb 2008 19:04:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Sam Ravnborg <sam@ravnborg.org>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux Tiny)
Message-ID: <20080215180456.GA517@one.firstfloor.org>
References: <20080212110825.35db27cb@crazy> <20080212130428.GA32757@uranus.ravnborg.org> <20080212150013.57cb954e@crazy> <1202832132.12383.93.camel@cinder.waste.org> <p73tzkazaxh.fsf@bingen.suse.de> <1203094937.12383.212.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203094937.12383.212.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do when it does". There's very little point in having this sort of code
> in a mass-market camera, phone, DVR, TV, etc. (of which there are

Do any of them run with a x86 CPU?

-Andi
