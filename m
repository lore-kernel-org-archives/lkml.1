Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZGRMLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZGRMLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZGRMLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:11:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZGRMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:11:35 -0400
Message-ID: <4A61BBC0.5070706@zytor.com>
Date: Sat, 18 Jul 2009 08:10:40 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090718100050.GB24164@elte.hu>
In-Reply-To: <20090718100050.GB24164@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I'm also wondering whether including LGPL glibc code in the kernel 
> like this is license-appropriate - there seems to be few precedents 
> of it. It _should_ be OK, but i've Cc:-ed involved folks just to 
> make sure everyone agrees ...
> 

Doesn't seem any more odd to me than BSD/GPL dual-licensing, which we 
already have tons of.

	-hpa
