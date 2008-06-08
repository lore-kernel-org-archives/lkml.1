Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYFHUf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYFHUf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYFHUfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:35:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbYFHUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:35:15 -0400
Date: Sun, 8 Jun 2008 13:34:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 00/14] bootmem rewrite v4
Message-Id: <20080608133447.e5293600.akpm@linux-foundation.org>
In-Reply-To: <20080605224940.434439989@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 00:49:40 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:

> This is a complete overhaul of the bootmem allocator while preserving
> most of its original functionality.

Confused.  This conflicts with patches from yourself which I have already
merged.
