Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbXKLLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbXKLLK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 06:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXKLLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:10:17 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34902 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXKLLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:10:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: ciol <ciol13@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
References: <fgtfqa$h9j$1@ger.gmane.org>
Date: Mon, 12 Nov 2007 04:09:27 -0700
In-Reply-To: <fgtfqa$h9j$1@ger.gmane.org> (ciol13@gmail.com's message of "Wed,
	07 Nov 2007 23:56:57 +0100")
Message-ID: <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ciol <ciol13@gmail.com> writes:

> Hi, I'd like to ask you a few questions:
>
> * Do you like the way linux distributions integrate the kernel?
>
> * Wouldn't you prefer they ship with the stable and still maintained 2.6.16.X,
> while providing optionally the latest kernel for those who want or just have a
> new hardware?
>
> * Do you think the megafreeze development model [1] and the "I don't trust in
> upstream" development model are broken? (And why)


I think a megafreeze development model is sane.  Finding a collection
of software versions that are all known to work together is very
interesting, and useful.  Making it so you can deliver something that
just works to end users is always interesting.

The only thing you miss out on are new features like the latest hardware
support.

I think forking packages just so you can claim they are frozen is a
dubious practice.  Especially if features are added in those forks.
(Yes new hardware support is a feature).

Eric
