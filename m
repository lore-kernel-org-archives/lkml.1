Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYGVSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYGVSqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYGVSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:46:29 -0400
Received: from il.qumranet.com ([212.179.150.194]:53046 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGVSq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:46:28 -0400
Message-ID: <48862B01.7070907@qumranet.com>
Date: Tue, 22 Jul 2008 21:46:25 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com>
In-Reply-To: <488604F8.1040008@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> That's true - as long as you don't have to add/remove/modify
> tracepoints. I had to do this job in the past (not for KVM). Having 1
> spot in 1 file (based on generic probes) would be handier in that case
> than 5 spots in 3 files. But if the KVM tracepoints are considered
> stable in their number and structure, that shouldn't be an issue here.
>
>   

Tracepoints aren't stable; they are artefacts of the implementation.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

