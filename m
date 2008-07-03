Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbYGCHK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbYGCHK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYGCG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbYGCEyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:54:04 -0400
Date: Wed, 2 Jul 2008 21:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: inux-next: Tree for July 1
Message-Id: <20080702215306.61367733.akpm@linux-foundation.org>
In-Reply-To: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 allmodconfig:

In file included from include/asm/pgtable.h:1087,
                 from include/linux/mm.h:39,
                 from arch/s390/mm/hugetlbpage.c:8:
include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
include/asm-generic/pgtable.h:209: error: dereferencing pointer to incomplete type
