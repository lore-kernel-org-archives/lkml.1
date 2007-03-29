Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXC2Ki4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXC2Ki4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030197AbXC2Ki4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:38:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:51596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXC2Kiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:38:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
Date: Thu, 29 Mar 2007 12:13:05 +0200
User-Agent: KMail/1.9.5
Cc: "Yinghai Lu" <yinghai.lu@amd.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com> <86802c440703282148w29732dcfy5b41a244fad6be4e@mail.gmail.com> <m1bqicmy7u.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqicmy7u.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291213.05390.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ---
> From: Yinghai Lu <yinghai.lu@amd.com>
> Subject: x86_64 irq: Fix comments after changing IRQ0_VECTOR from 0x20 to 0x30

applied thanks

-Andi
