Return-Path: <linux-kernel-owner+w=401wt.eu-S1763456AbXGPLyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763456AbXGPLyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXGPLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:54:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3939 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXGPLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:54:10 -0400
Date: Mon, 16 Jul 2007 13:54:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <20070716114734.GA12010@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161353350.1818@scrub.home>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home>
 <20070716114734.GA12010@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> i dont think there's any significant overhead. The OLPC folks are pretty 
> sensitive to performance,

How is a sleep function relevant to performace?

bye, Roman
