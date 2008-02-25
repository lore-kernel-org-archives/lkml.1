Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYBYEbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYBYEbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 23:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYBYEa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 23:30:58 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44057 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYBYEa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 23:30:57 -0500
Message-ID: <47C24453.5010808@ak.jp.nec.com>
Date: Mon, 25 Feb 2008 13:30:11 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] exporting capability name/code pairs (final)
References: <47BE2A29.4010302@ak.jp.nec.com> <47BE9B29.2070802@cn.fujitsu.com>
In-Reply-To: <47BE9B29.2070802@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> [2/3] Exporting capability code/name pairs
>>
>> This patch enables to export code/name pairs of capabilities the running
>> kernel supported.
>>
> 
> supported or supports ?

It seems to me "supports" is more appropriate one.

The original one might mention legacy versions. :-(

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
