Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0BCLC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:02:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0BCLCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:02:53 -0500
Message-ID: <4B69575A.5050403@cn.fujitsu.com>
Date: Wed, 03 Feb 2010 19:00:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Use O_LARGEFILE to open perf data
 file
References: <4B68F32A.9040203@cn.fujitsu.com> <tip-b8f46c5a34fa64fd456295388d18f50ae69d9f37@git.kernel.org> <4B69409E.9010301@zytor.com>
In-Reply-To: <4B69409E.9010301@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:

> 
> Setting _FILE_OFFSET_BITS *and* using O_LARGEFILE, lseek64, etc, is
> redundant...
> 

Ah, i forgot this, i'll send a patch to fix it soon. Thanks Peter!

- Xiao
