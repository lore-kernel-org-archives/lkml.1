Return-Path: <linux-kernel-owner+w=401wt.eu-S935231AbYEUX5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231AbYEUX5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbYEUX5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:57:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYEUX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:57:02 -0400
Message-ID: <4834B6AC.9090503@zytor.com>
Date: Wed, 21 May 2008 16:56:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com> <20080520131943.GA4843@redhat.com>
In-Reply-To: <20080520131943.GA4843@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> From conversation with Centaur engineers, both the newer generations
> of the VIA C7, and their future CPUs support PAT, with no known errata.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 

Question: are there any VIA CPUs that display the PAT CPUID flag that 
aren't covered by the above?

	-hpa
