Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864Ab0A2Xdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0A2Xdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094Ab0A2Xde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:33:34 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40939 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0A2Xdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:33:33 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the davinci tree with the arm tree
References: <20100129111342.203358d9.sfr@canb.auug.org.au>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 29 Jan 2010 15:33:29 -0800
In-Reply-To: <20100129111342.203358d9.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Fri\, 29 Jan 2010 11\:13\:42 +1100")
Message-ID: <87iqakpjue.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Kevin,
>
> Today's linux-next merge of the davinci tree got a conflict in
> arch/arm/mach-bcmring/core.c between commit
> dd84ce18c8f522d26aef6e9e9c05c32485b667a7 ("ARM: Consolidate
> clks_register() and similar") from the arm tree and commit
> 25c692215f5dfc4992b11c4fb57538d1139d6636 ("Consolidate clks_register()
> and similar") from the davinci tree.
>
> The davinci tree version has a typo (ARRAY_SIEZ v. ARRAY_SIZE) so I used
> the arm tree version.

OK, I'll drop the one from the davinci tree.

Thanks,

Kevin



