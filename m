Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZK3KMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZK3KMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZK3KMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:12:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZK3KMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:12:19 -0500
Message-ID: <4B139A3F.4030505@redhat.com>
Date: Mon, 30 Nov 2009 12:11:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving sched_in_preempt_notifers
References: <4AFD2801.7020900@kernel.org> <20091113095516.GD1364@elte.hu> <4AFEAB6D.60600@redhat.com> <4B138BC8.3090008@kernel.org> <4B13942E.3000002@redhat.com> <20091130100049.GA7054@elte.hu>
In-Reply-To: <20091130100049.GA7054@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 12:00 PM, Ingo Molnar wrote:
>
> that sched/urgent commit is not queued up for 2.6.32 (Linus indicated
> there wont be an -rc9), it spills over to the 2.6.33 merge window.
>    

It shouldn't go into .33 either, until we figure out how to fix it.

-- 
error compiling committee.c: too many arguments to function

