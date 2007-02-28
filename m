Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXB1G2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXB1G2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 01:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXB1G2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 01:28:21 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46076 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXB1G2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 01:28:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Lu, Yinghai" <yinghai.lu@amd.com>
Cc: ebiederm@xmission.com, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Zwane Mwaikambo" <zwane@infradead.org>,
       "Ashok Raj" <ashok.raj@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>, "Andi Kleen" <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 09/14] x86_64 irq: Begin consolidating per_irq data in structures.
References: <5986589C150B2F49A46483AC44C7BCA4907458@ssvlexmb2.amd.com>
Date: Tue, 27 Feb 2007 23:27:13 -0700
In-Reply-To: <5986589C150B2F49A46483AC44C7BCA4907458@ssvlexmb2.amd.com>
	(Yinghai Lu's message of "Tue, 27 Feb 2007 13:28:07 -0800")
Message-ID: <m1vehmkda6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Lu, Yinghai" <yinghai.lu@amd.com> writes:
>
> Why not use
>
> IRQ0_VECTOR... IRQ15_VECTOR here. 

I do by the end of the patch series it was a patch ordering issue.

Eric
