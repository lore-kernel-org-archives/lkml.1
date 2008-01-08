Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYAHWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYAHWP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYAHWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:34 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47847
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbYAHWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-Id: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a series which goes some way to tidying up pgtable.h.  It is
not complete yet, but this lot compiles and works for me.

In many cases I've moved code around with no attempt at adjusting the
formatting to acceptible style.  That can be done in a later patch,
but it means that checkpatch is noisy with this lot.

Thanks,
	J


