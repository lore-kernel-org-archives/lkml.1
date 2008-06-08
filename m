Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYFHVxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYFHVxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYFHVxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:53:34 -0400
Received: from saeurebad.de ([85.214.36.134]:33038 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbYFHVxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:53:34 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 00/14] bootmem rewrite v4
References: <20080605224940.434439989@saeurebad.de>
	<20080608133447.e5293600.akpm@linux-foundation.org>
Date: Sun, 08 Jun 2008 23:52:47 +0200
In-Reply-To: <20080608133447.e5293600.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sun, 8 Jun 2008 13:34:47 -0700")
Message-ID: <87fxrnmw5s.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 06 Jun 2008 00:49:40 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> This is a complete overhaul of the bootmem allocator while preserving
>> most of its original functionality.
>
> Confused.  This conflicts with patches from yourself which I have already
> merged.

Hum.  I just tried again:

- checkout v2.6.26-rc5
- get latest mmotm broken-out tarball (stamp-2008-06-07-02-27)
- git-quiltimport
- apply the bootmem series

and no conflicts.  Anything I missed?  Which files are conflicting, btw?

	Hannes
