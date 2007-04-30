Return-Path: <linux-kernel-owner+w=401wt.eu-S1946619AbXD3Su4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946619AbXD3Su4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946617AbXD3Su4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:50:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946620AbXD3Sug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:50:36 -0400
Date: Mon, 30 Apr 2007 11:50:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu scheduler
Message-Id: <20070430115014.0fff7772.akpm@linux-foundation.org>
In-Reply-To: <200703271210.39429.kernel@kolivas.org>
References: <200703271210.39429.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 13:10:39 +1100
Con Kolivas <kernel@kolivas.org> wrote:

> Staircase Deadline cpu scheduler policy

I'll be dropping this from -mm now.  I don't think we're learning anything
more by having it in there and I generally want to get things more back
into sync.

For the record, I don't recall any problem reports arising from SD's
presence in -mm (Except for possibly Jiri's recent "many processes end up
in D state", but we don't have a clue what's causing that yet).


