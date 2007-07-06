Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXGFWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXGFWe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbXGFWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:34:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758113AbXGFWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:34:21 -0400
Date: Fri, 6 Jul 2007 15:34:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: Re: [PATCH] memory unplug v7 - introduction
Message-Id: <20070706153401.d1d6bf88.akpm@linux-foundation.org>
In-Reply-To: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 18:19:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This is a memory unplug base patch set against 2.6.22-rc6-mm1.

Well I stuck these in -mm, but I don't know what they do.  An overall
description of the design would make any review much more effective.

ie: what does it all do, and how does it do it?

Also a description of the test setup and the testing results would be
useful.


