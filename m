Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZE3AYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZE3AYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 20:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZE3AYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 20:24:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:55249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZE3AYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 20:24:02 -0400
Message-ID: <4A207C76.20502@kernel.org>
Date: Fri, 29 May 2009 17:23:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: GeunSik Lim <leemgs1@gmail.com>
CC: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Fix COMM and MMAP events
 	for cpu wide counters
References: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org> <49b7c2350905291715v2ff53a96o98a0fd195ee27dc9@mail.gmail.com>
In-Reply-To: <49b7c2350905291715v2ff53a96o98a0fd195ee27dc9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GeunSik Lim wrote:
>> On Sat, May 30, 2009 at 2:16 AM, tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> Commit-ID:  efb3d17240d80e27508d238809168120fe4b93a4
>> Gitweb:     http://git.kernel.org/tip/efb3d17240d80e27508d238809168120fe4b93a4
> 
> I have one question about "tip-bot" and "-tip" word.
> "tip" word is abbreviation. Can anyone explain me meaning  of the "tip" word?
> Sorry for trivial question.
> But I always wondered about this abbreviation in private.
> 
> 
T: Thomas
I: Ingo
P: hpa

YH
