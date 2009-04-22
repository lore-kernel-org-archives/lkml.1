Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZDVOSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZDVOSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDVOSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:18:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZDVOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:18:24 -0400
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Idea: Feature information / extensions dispatcher syscall.
From: Andi Kleen <andi@firstfloor.org>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
Date: Wed, 22 Apr 2009 16:18:17 +0200
In-Reply-To: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com> (Igor Zhbanov's message of "Wed, 22 Apr 2009 18:12:07 +0400")
Message-ID: <871vrkpyae.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Zhbanov <izh1979@gmail.com> writes:
>
> This allow to use system calls in any extension modules without need to reserve
> syscall number in kernel source and allow binaries to run correctly on
> any kernel
> (where that extension feature can have another syscall number).
>
> What do you think?

You're trying to reinvent the vfs / device nodes / ioctls

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
