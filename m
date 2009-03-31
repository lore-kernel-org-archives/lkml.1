Return-Path: <linux-kernel-owner+w=401wt.eu-S1765826AbZCaXom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765826AbZCaXom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765741AbZCaXoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:44:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765728AbZCaXoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:44:14 -0400
Date: Wed, 1 Apr 2009 01:39:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Message-ID: <20090331233958.GA28228@redhat.com>
References: <20090331144229.A11867@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331144229.A11867@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Markus Metzger wrote:
>
> The first 5 patches apply to .29 with the small preparation patch below.

Tried to review these patches.

As I said, I don't understand ds.c, but I _think_ these changes are good.

I only have a couple of really minor nitpicks...

Oleg.

