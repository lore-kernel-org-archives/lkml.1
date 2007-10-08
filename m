Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbXJHUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbXJHUES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXJHUEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:04:08 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44371 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXJHUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:04:07 -0400
Date: Mon, 8 Oct 2007 13:43:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: SCHED_NO_NO_OMIT_FRAME_POINTER
Message-ID: <Pine.LNX.4.64.0710081337480.5028@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I nearly had to visit a psychiatrist when I selected "n" to
SCHED_NO_NO_OMIT_FRAME_POINTER in 2.6.23-rc8-mm2: sorry if
I'm spoiling an in-joke, but is there any chance that could
be changed (with reversed sense) to SCHED_FRAME_POINTER?

Hugh
