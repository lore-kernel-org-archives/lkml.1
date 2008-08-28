Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYH1PUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYH1PUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYH1PUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:20:03 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:38209 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbYH1PUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:20:02 -0400
Date: Thu, 28 Aug 2008 11:19:40 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make poll_idle behave more like the other idle methods
Message-ID: <20080828151940.GA21854@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827143506.GA23166@tsunami.ccur.com> <20080828090036.GC19422@elte.hu> <20080828132237.GA20926@tsunami.ccur.com> <20080828133335.GA1126@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828133335.GA1126@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 09:33:35AM -0400, Ingo Molnar wrote:
>> I saw the outer loop running continuously, from the old
>> trace patch which I had applied.
> 
> ah - was that an older version of ftrace?

Believe it or not, it's a very old version of LTTng trace.

We have a guy that keeps dragging it forward (compatibility
reasons).

Joe
