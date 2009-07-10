Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZGJWqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZGJWqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZGJWq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:46:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZGJWq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:46:26 -0400
Message-ID: <4A57C57A.1090200@redhat.com>
Date: Sat, 11 Jul 2009 01:49:30 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: KSM: current madvise rollup
References: <Pine.LNX.4.64.0906291419440.5078@sister.anvils> <4A49E051.1080400@redhat.com> <Pine.LNX.4.64.0906301518370.967@sister.anvils> <4A4A5C56.5000109@redhat.com> <Pine.LNX.4.64.0907010057320.4255@sister.anvils> <4A4B317F.4050100@redhat.com> <Pine.LNX.4.64.0907082035400.10356@sister.anvils> <4A57C3D1.7000407@redhat.com>
In-Reply-To: <4A57C3D1.7000407@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> Hugh Dickins wrote:
>>
> Hey Hugh,
>
> I started to hack the code around to make sure i understand 
> everything, and in addition i wanted to add few things
>
> One thing that catched my eyes was:
Forgot about that thing, It isn't true what i said there - Silly mistake 
from my side, but please read the bottom part about the - number of 
merged pages per process statistics.

Sorry.
