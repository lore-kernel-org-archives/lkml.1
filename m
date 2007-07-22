Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbXGVWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbXGVWCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764539AbXGVWCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:02:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXGVWCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:02:01 -0400
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
	<6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jul 2007 00:56:54 +0200
In-Reply-To: <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
Message-ID: <p73zm1ot5c9.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Oliver Pinter" <oliver.pntr@gmail.com> writes:
> 
> Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
> for help, because number of person has the question: I have Pentium D,
> and which CPU chose  I.

Your patch does a lot more than that; please do only one thing per patch.
Also x86-64 probably should get it too.

-Andi

