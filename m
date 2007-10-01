Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbXJAJd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbXJAJd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXJAJdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:33:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXJAJdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:33:50 -0400
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86_64 and AMD with C1E
References: <20071001101532.025d652f@localhost>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 11:33:48 +0200
In-Reply-To: <20071001101532.025d652f@localhost>
Message-ID: <p73r6kf6uwz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> writes:
> 
> The same situation can be observed for linux-2.6.22.

You're saying 2.6.22/x86-64 without any patches doesn't boot out of the box 
with C1E enabled? If yes what are the exact symptoms?

-Andi
