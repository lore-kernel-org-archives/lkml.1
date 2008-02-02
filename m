Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbYBBJH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbYBBJH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbYBBJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:06:58 -0500
Received: from gw.goop.org ([64.81.55.164]:56610 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbYBBJG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:06:56 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 7] x86: more pgalloc unification
Message-Id: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series does more unification of pgalloc, and creates a unified
mm/pgtable.c for common pagetable functions.  Ends up removing
pgalloc_32/64.h in favour of pgalloc.h.

[ I thought I'd mailed this earlier, but I don't see it on lkml.
Maybe I created the mbox without sending it.  Anyway, this should go
before the set I just mailed. ]

Thanks,
	J


