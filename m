Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYGCL4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYGCL4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYGCLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:55:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYGCLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:54 -0400
Date: Thu, 3 Jul 2008 02:37:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>, linux-kernel@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:
 Setup routines
Message-Id: <20080703023702.6968880a.akpm@linux-foundation.org>
In-Reply-To: <20080703092052.GA5548@elte.hu>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
	<20080703092052.GA5548@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 11:20:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 1) please rebase your patches ontop of -mm, which carries the oprofile 
> multiplexing cleanups and enhancements already which heavily interact 
> with your patchset.

I dropped those.  Because it's obvious that significant changes are
to be made.  So I guess working against linux-next is appropriate for
this change.
