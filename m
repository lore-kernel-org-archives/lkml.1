Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYEVUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYEVUYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYEVUYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:24:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYEVUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:24:40 -0400
Message-ID: <4835D64A.5070703@zytor.com>
Date: Thu, 22 May 2008 13:23:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com> <20080520131943.GA4843@redhat.com> <4834B6AC.9090503@zytor.com> <20080522140753.GB20613@redhat.com> <4835A3EC.1030307@zytor.com> <20080522170223.GA32314@redhat.com>
In-Reply-To: <20080522170223.GA32314@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> Like so?
> 
> Unconditionally enable PAT support on Centaur and Transmeta CPUs.
> All known models that advertise PAT have no known errata.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

Eventually the whitelist should decay into a blacklist.

	-hpa
