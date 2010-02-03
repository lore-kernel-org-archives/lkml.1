Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0BCPMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:12:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab0BCPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:12:08 -0500
Date: Wed, 3 Feb 2010 07:08:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-Id: <20100203070825.e36b3932.akpm@linux-foundation.org>
In-Reply-To: <20100203133951.GA24357@localhost>
References: <20100130094515.475881280@intel.com>
	<20100130094957.692671259@intel.com>
	<20100201124825.cc024f2a.akpm@linux-foundation.org>
	<20100203133951.GA24357@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 21:39:51 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> Is there an official lowest GCC version that Linux supports?

Documentation/Changes says gcc-3.2.
