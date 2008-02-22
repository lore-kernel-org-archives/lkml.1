Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbYBVS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbYBVS5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYBVS5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:57:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYBVS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:57:35 -0500
Message-ID: <47BF1B85.3050001@firstfloor.org>
Date: Fri, 22 Feb 2008 19:59:17 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
References: <200802210258.45011.yinghai.lu@sun.com> <p73hcg189g1.fsf@bingen.suse.de> <200802221102.31019.yinghai.lu@sun.com> <200802221108.20976.yinghai.lu@sun.com>
In-Reply-To: <200802221108.20976.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> or move
> CPUs have X86_FEATURE_CONSTANT_TSC check before apic_clustered check?

No that would be not correct on Intel boxes.

-Andi
