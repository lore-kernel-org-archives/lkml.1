Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYGPM5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYGPM5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYGPM5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:57:47 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1948 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYGPM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:57:46 -0400
Date: Wed, 16 Jul 2008 14:57:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: john stultz <johnstul@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  fix rounding problem during clock update
In-Reply-To: <1216177633.6294.46.camel@localhost>
Message-ID: <Pine.LNX.4.64.0807161454320.6791@localhost.localdomain>
References: <1216177633.6294.46.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 Jul 2008, john stultz wrote:

> So I had assumed this was picked up already, but apparently it somehow
> got lost in the early 2.6.26 time-frame.
> 
> Anyway, I pinged Roman about it, but he hasn't responded, so I wanted to

Sorry about that, I wanted to update and test the patches over the 
weekend, but other things kept me busy. I'll sent the other patches out 
this week.

bye, Roman
