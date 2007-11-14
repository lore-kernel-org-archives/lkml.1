Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbXKNP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbXKNP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbXKNP5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:57:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43018 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbXKNP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:57:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: olof@lixom.net, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix warning for token-ring from sysctl checker
References: <20071113072313.GB16842@lixom.net>
	<20071113.211540.97775009.davem@davemloft.net>
Date: Wed, 14 Nov 2007 08:56:20 -0700
In-Reply-To: <20071113.211540.97775009.davem@davemloft.net> (David Miller's
	message of "Tue, 13 Nov 2007 21:15:40 -0800 (PST)")
Message-ID: <m1r6is253v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Olof Johansson <olof@lixom.net>
> Date: Tue, 13 Nov 2007 01:23:13 -0600
>
>> As seen when booting ppc64_defconfig:
>> 
>> sysctl table check failed: /net/token-ring .3.14 procname does not match
> binary path procname
>> 
>> 
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>
> Patch applied, thanks Olof.

No objections but I think we already have this fixed in the -mm tree.

Eric

