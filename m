Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbZLOOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbZLOOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZLOOJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:09:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39303 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbZLOOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:09:56 -0500
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering support
From: Andi Kleen <andi@firstfloor.org>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 15:09:54 +0100
In-Reply-To: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com> (Daisuke HATAYAMA's message of "Tue, 15 Dec 2009 11:41:49 +0900 (JST)")
Message-ID: <87k4wowcp9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> writes:

> diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
> index 4e320f0..4e34e47 100644
> --- a/arch/um/sys-i386/elfcore.c
> +++ b/arch/um/sys-i386/elfcore.c

Again you only seem to patch UML, not real x86 (arch/x86/*) ?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
