Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZBEWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZBEWZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZBEWZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:25:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792AbZBEWZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:25:37 -0500
Date: Thu, 5 Feb 2009 14:25:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-mm@kvack.org, andrea@qumranet.com, npiggin@suse.de,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
 retain extra mm_count.
Message-Id: <20090205142527.59bddf45.akpm@linux-foundation.org>
In-Reply-To: <20090205172303.GB8559@sgi.com>
References: <20090205172303.GB8559@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 11:23:03 -0600
Robin Holt <holt@sgi.com> wrote:

> CC: Stable kernel maintainers <stable@vger.kernel.org>

stable@kernel.org.

The vger address might work, I don't know.
