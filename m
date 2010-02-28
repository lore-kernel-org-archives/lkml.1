Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031668Ab0B1JIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 04:08:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:42545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031657Ab0B1JIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 04:08:41 -0500
Message-ID: <4B8A31DD.4000408@kernel.org>
Date: Sun, 28 Feb 2010 01:05:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       garyhade@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       trenn@suse.de
Subject: Re: [PATCH -v11] x86: fix out of order of gsi -- partial
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org> <4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org> <4B89E751.1060903@kernel.org> <20100228080941.GD14205@elte.hu>
In-Reply-To: <20100228080941.GD14205@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 12:09 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> From: Eric W. Biederman <ebiederm@xmission.com>
>>
>> found IBM x3950 will have problem after
>>
>> |commit b9c61b70075c87a8612624736faf4a2de5b1ed30
> 
> Have you seen the commit notifications i sent for the v8 patches:
> 
> Commit-ID:  ca8c764cb39bf6cade71933b38e8c830eb8b73c6
> Commit-ID:  519d637a93116ffbcd50e9e3f2591f41584f372c
> 
> Those include a much improved changelogs - please adopt those. (and preferably 
> send deltas against tip:tmp.x86/apic.)

please drop those two.

will send v12 to you.

Thanks

Yinghai
