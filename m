Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbYDSK4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbYDSK4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYDSK4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:56:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbYDSK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:56:23 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: x86: 4kstacks default
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 19 Apr 2008 12:56:09 +0200
References: <ak6tq-32p-7@gated-at.bofh.it> <ak6tq-32p-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JnAjp-0000kW-Gv@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/OCQCdtM5E5dIbNnZAgb7DAqXny/D3tcEkQon
 7re/UZyjb4pOsZj3N4tdT/7X6RGyPahqABKvbQWarP/y7CEeQH
 k9rCUKLhiBXHmKTcj7+tA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

>> Gitweb:    
>>
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d61ecf0b53131564949bc4196e70f676000a845a
>> Commit:     d61ecf0b53131564949bc4196e70f676000a845a
>> Author:     Ingo Molnar <mingo@elte.hu>
>> Committer:  Ingo Molnar <mingo@elte.hu>

>>     x86: 4kstacks default

> This patch will cause kernels to crash.
> 
> It has no changelog which explains or justifies the alteration.
> 
> afaict the patch was not posted to the mailing list and was not
> discussed or reviewed.

The patch (or a similar one) was discussed and rejected for the reason above.

