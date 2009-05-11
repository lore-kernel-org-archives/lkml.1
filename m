Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZEKVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZEKVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbZEKVQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:16:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40474 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZEKVQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:16:55 -0400
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disable generation of sse3 instructions in kernel build.
From: Andi Kleen <andi@firstfloor.org>
References: <200905091903.25745.lkml@morethan.org>
Date: Mon, 11 May 2009 23:16:49 +0200
In-Reply-To: <200905091903.25745.lkml@morethan.org> (Michael S. Zick's message of "Sat, 9 May 2009 19:03:22 -0500")
Message-ID: <87skjbmjb2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Zick" <lkml@morethan.org> writes:

> Ref: 2.6.30-rcX
> The option to disable sse3 instructions needs to be added to build system for x86.
> Otherwise strange and mysterious things happen (tm).

Can you please expand a little bit? With what compiler version did you
see problems? And in what area did they happen?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
