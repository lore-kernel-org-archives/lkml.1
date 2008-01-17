Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYAQB4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYAQB4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYAQBzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:55:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYAQBzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:55:54 -0500
Message-ID: <478EB5A5.6080406@cn.fujitsu.com>
Date: Thu, 17 Jan 2008 09:55:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "local_t Documentation update"
References: <478EB2CC.8000900@cn.fujitsu.com> <20080117014813.GA2322@Krystal>
In-Reply-To: <20080117014813.GA2322@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Li Zefan (lizf@cn.fujitsu.com) wrote:
>> This reverts commit e1265205c0ee3919c3f2c750662630154c8faab2.
>>
>> It's a duplicate commit of commit 74beb9db77930be476b267ec8518a642f39a04bf,
>> resulting in a duplicate section.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>
> 
> Thanks, I guess it's been merged twice somehow :S
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 

Yeap, I guess so.
