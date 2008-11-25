Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYKYQ5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYKYQ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYKYQ4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:56:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYKYQ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:56:55 -0500
Message-ID: <492C2E12.5000103@redhat.com>
Date: Tue, 25 Nov 2008 18:55:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       suparna@in.ibm.com, linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu> <20081125151058.GX26308@kernel.dk> <492C1904.9020309@oracle.com>
In-Reply-To: <492C1904.9020309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> And there's still the question of what ptrace is supposed to do.
>   

If it's kernel-only (which I think is a good start for something like 
this), then is ptrace relevant at all?

-- 
error compiling committee.c: too many arguments to function

