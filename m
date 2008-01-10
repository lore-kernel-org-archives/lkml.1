Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYAJTKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYAJTKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYAJTKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:10:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:59239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYAJTKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:10:21 -0500
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.co, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 03/11] PAT x86: Map only usable memory in i386 identity map
From: Andi Kleen <andi@firstfloor.org>
References: <20080110184840.927409000@intel.com>
	<20080110184855.000724000@intel.com>
Date: Thu, 10 Jan 2008 20:10:19 +0100
In-Reply-To: <20080110184855.000724000@intel.com> (venkatesh pallipadi's message of "Thu\, 10 Jan 2008 10\:48\:43 -0800")
Message-ID: <p73ve61mr8k.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:

> i386: Map only usable memory in identity map. Reserved memory maps to a
> zero page.

Same comments as for x86-64 version.

-Andi
