Return-Path: <linux-kernel-owner+w=401wt.eu-S965191AbZLGXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191AbZLGXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965178AbZLGXZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:25:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965112AbZLGXZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:25:20 -0500
Message-ID: <4B1D8F53.1090200@gmail.com>
Date: Tue, 08 Dec 2009 00:27:15 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Emese Revfy <re.emese@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/31] Constify struct extent_io_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198B4C.3030201@gmail.com> <20091207141229.GB1710@think>
In-Reply-To: <20091207141229.GB1710@think>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Fri, Dec 04, 2009 at 11:21:00PM +0100, Emese Revfy wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> Constify struct extent_io_ops.
>>
>> Signed-off-by: Emese Revfy <re.emese@gmail.com>
>> ---
>>  fs/btrfs/disk-io.c   |    4 ++--
>>  fs/btrfs/extent_io.h |   30 +++++++++++++++---------------
>>  fs/btrfs/inode.c     |    4 ++--
>>  3 files changed, 19 insertions(+), 19 deletions(-)
>>
> 
> Thanks, I'll pick this up in the btrfs tree unless Linus has already
> grabbed it.
> 
> -chris

He hasn't responded so far, so feel free to pick it up yourself.
Thanks, Emese

