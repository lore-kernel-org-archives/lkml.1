Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZFASMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZFASMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZFASMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:12:32 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52946 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZFASMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:12:31 -0400
Date: Mon, 1 Jun 2009 23:42:22 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090601181222.GA23582@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,
	Please find a new patchset that contains a slight re-arrangement in the
patchset as suggested by you here: http://lkml.org/lkml/2009/5/30/165.

The 'struct thread_struct' is modified to contain an array-based storage for
debug register in Patch 01/12 and all users of debugreg<n> are also modified in
the same patch.

Kindly integrate them to be a part of -tip tree.

Thanks,
K.Prasad


