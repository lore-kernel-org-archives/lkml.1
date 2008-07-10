Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYGJCpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYGJCpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYGJCp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:45:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbYGJCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:45:26 -0400
Date: Wed, 9 Jul 2008 19:38:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 17/34] AMD IOMMU: add generic defines and structures for
 mapping code
Message-Id: <20080709193830.ed82fcec.akpm@linux-foundation.org>
In-Reply-To: <20080709190140.ab662def.akpm@linux-foundation.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-18-git-send-email-joerg.roedel@amd.com>
	<20080709190140.ab662def.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 19:01:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> It is unobvious whether this haler has correct behaviour with all mixes of

                               helper

> 32-bit and 64-bit signed and unsigned types.

One of my more wild typos.
