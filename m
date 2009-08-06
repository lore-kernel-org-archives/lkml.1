Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZHFHzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZHFHzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZHFHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:55:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56070 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZHFHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:55:10 -0400
Message-ID: <4A7A8CC3.9060901@redhat.com>
Date: Thu, 06 Aug 2009 15:56:51 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112133.6552.69619.sendpatchset@localhost.localdomain> <87zlaeiakr.fsf@basil.nowhere.org> <4A7A3807.8090803@redhat.com> <20090806071526.GA22124@basil.fritz.box>
In-Reply-To: <20090806071526.GA22124@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hardcoding the size doesn't really make any sense to me, especially
> a suspicious one like 128MB.
>   

Er, don't worry about this is too large, I am working on a patch which 
will allow us to remove the unnecessary reserved memory from user space. :)

