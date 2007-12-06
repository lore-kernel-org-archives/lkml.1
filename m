Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbXLFRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbXLFRtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXLFRtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:49:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXLFRtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:49:11 -0500
Date: Thu, 6 Dec 2007 12:48:23 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-ID: <20071206124823.0e87a0a1@cuia.boston.redhat.com>
In-Reply-To: <20071206093432.096213fe.akpm@linux-foundation.org>
References: <200712051603.02183.phillips@phunq.net>
	<200712052221.45409.phillips@phunq.net>
	<20071205233152.c567fa57.akpm@linux-foundation.org>
	<200712060148.53805.phillips@phunq.net>
	<20071206035511.83bef995.akpm@linux-foundation.org>
	<20071206105242.3e289a21@cuia.boston.redhat.com>
	<20071206093432.096213fe.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 09:34:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> That's all rather handwavy and misses a lot of details and might be
> inaccurate too.  Probably sufficient to just work out by hand the amount of
> memory which the network stack will need to allocate.  I expect it'll be
> two pages..

Doesn't Peter Zijlstra's patch series take care of all those
nasty details already?

-- 
All Rights Reversed
