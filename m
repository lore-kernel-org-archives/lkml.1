Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZLOOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZLOOFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbZLOOF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:05:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43425 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271AbZLOOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:05:26 -0500
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove ELF_CORE_EXTRA_* macro
From: Andi Kleen <andi@firstfloor.org>
References: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 15:05:24 +0100
In-Reply-To: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com> (Daisuke HATAYAMA's message of "Tue, 15 Dec 2009 11:41:18 +0900 (JST)")
Message-ID: <87skbcwcwr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> writes:
>  subarch-obj-$(CONFIG_MODULES) += kernel/module.o
> diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
> new file mode 100644
> index 0000000..4e320f0
> --- /dev/null
> +++ b/arch/um/sys-i386/elfcore.c

No code for real x86? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
