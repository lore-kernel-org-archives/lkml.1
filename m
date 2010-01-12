Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0ALI1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0ALI1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221Ab0ALI1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:27:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50319 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0ALI1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:27:12 -0500
Date: Tue, 12 Jan 2010 13:57:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
Message-ID: <20100112082706.GE28425@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263264483-3959-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 06:48:01PM -0800, Yinghai Lu wrote:

> not sure it works again, could be bios fix the irq routing dest ?

Nope, it doesn't. I applied this patchset.. no luck.

Ananth
