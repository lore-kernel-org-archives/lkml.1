Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666Ab0ABOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0ABOpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540Ab0ABOpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:45:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:37269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ABOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:45:39 -0500
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim
 too
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2f11576a1001020529l729caebawc4364690f1df56cb@mail.gmail.com>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
	 <1262387986.16572.234.camel@laptop>
	 <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
	 <1262429166.32223.32.camel@laptop>
	 <2f11576a1001020529l729caebawc4364690f1df56cb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 15:45:00 +0100
Message-ID: <1262443500.6408.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-02 at 22:29 +0900, KOSAKI Motohiro wrote:

> When recursive annotation occur?

Dunno, I told you you'd have to make sure it doesn't.

