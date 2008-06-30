Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbYF3Nop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbYF3Nop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbYF3No0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:44:26 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:55593 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923AbYF3NoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:44:13 -0400
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Temporary ACPI maintainer for this summer
Cc: lenb@kernel.org, torvalds@osdl.org, akpm@osdl.org, acpi@linux.intel.com
From: Andi Kleen <andi@firstfloor.org>
Date: Mon, 30 Jun 2008 15:43:33 +0200
Message-ID: <871w2fujga.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jun 2008 13:36:12.0570 (UTC) FILETIME=[4328A7A0:01C8DAB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Len Brown is on sabbatical from Intel this summer. While he's away
I'm serving as the temporary ACPI maintainer. Please send all ACPI
mails and patches you would normally send to Len to me, ideally cc
linux-acpi@vger.kernel.org.

As usual please put all ACPI bug reports into http://bugzilla.kernel.org.

First (in case he still reads that) I would like to thank Len (and all
the other ACPI hackers of course) for all the great work done on the ACPI
code in the last years, turning it from a problem child to a quite
respectable kernel subsystem.

I'm not as deep in all things ACPI as Len is, so I'll often rely on
the various other ACPI hackers for specific issues.

My main goal will be to merge patches from the usual contributors and
try to keep the ACPI bugs and regressions under control. I don't plan
many new features, but features already in progress will be processed
as they are ready.

I'm also not full time working on ACPI, but also active in other areas.
This means I will not write that many ACPI patches myself
or do extensive testing on my own, but mostly focus on review and merging 
and bug triage.

The git tree setup for the merges will be announced later.  I won't
directly use Len's tree.

I'll take over all patches Len has already queued, so no need to
resubmit them.  But if he doesn't have something acknowledged already
you want to be included, please retransmit it to me.

The .27 merge will be primarily patches Len has already queued
in his release tree.

-Andi
