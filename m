Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYEGOSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYEGOSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYEGORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:17:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51294 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYEGORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:17:47 -0400
Message-ID: <4821BA06.9020704@firstfloor.org>
Date: Wed, 07 May 2008 16:17:42 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: stephane eranian <eranian@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Subject: Re: [PATCH] perfmon: add context switch hooks for x86
References: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>
In-Reply-To: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> Hello,
> 
> 
> Here is a first perfmon patch. It provides the following:
> 
>    - minimal perfmon source tree layout with a topdir perfmon for
> generic code and
>      the x86 arch specific subdir in arch/x86.

How much larger would a patch be that does at least something minimally
useful? (like context switching the performance registers)

-Andi
