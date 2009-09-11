Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZIKIzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZIKIzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 04:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZIKIzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 04:55:03 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:34177 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZIKIzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 04:55:01 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	<873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu>
	<87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu>
	<87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu>
Date: Fri, 11 Sep 2009 08:55:02 +0000
In-Reply-To: <20090911061024.GA27833@elte.hu> (Ingo Molnar's message of "Fri,
	11 Sep 2009 08:10:24 +0200")
Message-ID: <87d45xoo7t.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Could still compare -j5 to -j4 on -tip, to see why -j4 is 3% short 
> of -j5's throughput.
>
> (Plus maybe the NEW_FAIR_SLEEPERS change in -tip fixes the 3% drop.)

Will do in about 12 hours or so.
