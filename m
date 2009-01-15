Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZAOCXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZAOCXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZAOCX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:23:26 -0500
Received: from ozlabs.org ([203.10.76.45]:57012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZAOCXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:23:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18798.40466.741696.758199@cargo.ozlabs.ibm.com>
Date: Thu, 15 Jan 2009 13:23:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive counter groups
In-Reply-To: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in the rfc branch of my perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc

Ingo - you can pull it into your perfcounters branch if you like.

Paul.
