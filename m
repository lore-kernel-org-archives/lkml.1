Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYA2GfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYA2GfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYA2GfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:35:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:51571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYA2GfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:35:01 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let LOG_BUF_SHIFT default to 17
From: Andi Kleen <andi@firstfloor.org>
References: <20080128221223.GE8767@does.not.exist>
Date: Tue, 29 Jan 2008 07:35:00 +0100
In-Reply-To: <20080128221223.GE8767@does.not.exist> (Adrian Bunk's message of "Tue\, 29 Jan 2008 00\:12\:23 +0200")
Message-ID: <p73fxwh6sx7.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> 16 kB is often no longer enough for a normal boot of an UP system.

Better would be to just disable by default/remove noisy messages
to make the kernel boot output shorter.

I think we got a lot of IMHO useless messages in there.

-Andi
