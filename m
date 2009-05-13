Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZEMG0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZEMG0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZEMG0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:26:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbZEMG0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:26:11 -0400
Date: Tue, 12 May 2009 23:21:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
Message-Id: <20090512232122.61f2d7c5.akpm@linux-foundation.org>
In-Reply-To: <1242112482.3283.1.camel@localhost.localdomain>
References: <1242112482.3283.1.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 12:44:42 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> +		   "ext cpuid level\t: 0x%x\n"

It's unobvious what "ext" means.  External?

Can we make it "extended cpuid level"?

One would hope that google(extended cpuid level) tells you what an
extended cpuid level is, but alas, unclear.

