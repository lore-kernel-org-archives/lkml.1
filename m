Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYG3Isu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYG3Isu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYG3Ism
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:48:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbYG3Ism (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:48:42 -0400
Date: Wed, 30 Jul 2008 01:43:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Munson <ebmunson@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-Id: <20080730014308.2a447e71.akpm@linux-foundation.org>
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 12:17:10 -0700 Eric Munson <ebmunson@us.ibm.com> wrote:

> Certain workloads benefit if their data or text segments are backed by
> huge pages.

oh.  As this is a performance patch, it would be much better if its
description contained some performance measurement results!  Please.
