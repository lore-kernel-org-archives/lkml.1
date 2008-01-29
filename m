Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYA2G3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYA2G3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYA2G2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:28:55 -0500
Received: from ns.suse.de ([195.135.220.2]:51070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYA2G2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:28:55 -0500
To: shdl@zakalwe.fi (Heikki Orsila)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt
From: Andi Kleen <andi@firstfloor.org>
References: <20080128230959.AA1A32BC98@zakalwe.fi>
Date: Tue, 29 Jan 2008 07:28:53 +0100
In-Reply-To: <20080128230959.AA1A32BC98@zakalwe.fi> (Heikki Orsila's message of "Tue\, 29 Jan 2008 01\:09\:59 +0200 \(EET\)")
Message-ID: <p73k5lt6t7e.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shdl@zakalwe.fi (Heikki Orsila) writes:
>  
> +Some complain that kernel interfaces change too often for out-of-the-tree
> +modules, but this claim is false. Changing an interface can be delicate work,
> +and it can take significant amount of developer effort. Therefore, interfaces
> +are not changed without a good reason.

This is actually not correct. Sometimes interfaces are changed
without good reason or the for reasons that turn out to be incorrect.

-Andi
