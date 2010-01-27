Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0A0AeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0A0AeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066Ab0A0AeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:34:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab0A0AeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:34:23 -0500
Date: Tue, 26 Jan 2010 16:32:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, shaohui.zheng@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] x86: remove bios data range from e820
Message-Id: <20100126163233.7ef1addb.akpm@linux-foundation.org>
In-Reply-To: <20100122033004.335813103@intel.com>
References: <20100122032102.137106635@intel.com>
	<20100122033004.335813103@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 11:21:04 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> To prepare move page_is_ram() as generic one.
> 
> Tested-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This should have included Signed-off-by:you, as you were on the patch
delivery path.  I shall add that.

