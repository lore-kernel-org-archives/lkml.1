Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbZJJJhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbZJJJhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZJJJha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:37:30 -0400
Received: from claw.goop.org ([74.207.240.146]:45231 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbZJJJha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:37:30 -0400
Message-ID: <4AD055B3.8070705@goop.org>
Date: Sat, 10 Oct 2009 02:36:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>	 <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins>
In-Reply-To: <1255166662.7866.28.camel@twins>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/09 02:24, Peter Zijlstra wrote:
> Is that a real issue? If its not supported by the early hardware virt
> chips, tough luck, they sucked anyway :-)
>   

Nehalem is the first Intel chip to support it, and Xen doesn't rely on
hardware virt support anyway.

    J
