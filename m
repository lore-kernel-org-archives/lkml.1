Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZE3ON6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZE3ON6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZE3ONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:13:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbZE3ONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:13:51 -0400
Message-ID: <4A213EFF.7030101@redhat.com>
Date: Sat, 30 May 2009 10:13:19 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: pageexec@freemail.hu
CC: Peter Zijlstra <peterz@infradead.org>,
       "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
References: <20090522073436.GA3612@elte.hu>, <4A211BA8.8585.17B52182@pageexec.freemail.hu>, <1243689707.6645.134.camel@laptop> <4A213AA8.18076.182E39C1@pageexec.freemail.hu>
In-Reply-To: <4A213AA8.18076.182E39C1@pageexec.freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pageexec@freemail.hu wrote:
> On 30 May 2009 at 15:21, Peter Zijlstra wrote:

>> Can we instead of working around a problem, fix the actual problem?
> 
> finding all use-after-free bugs is not possible, as far as i know.

Not only that, but new ones get introduced all the time.

-- 
All rights reversed.
