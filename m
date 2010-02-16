Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab0BPVi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:38:26 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:32924 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0BPViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:38:25 -0500
MIME-Version: 1.0
In-Reply-To: <20100215181335.f53ad8a0.sfr@canb.auug.org.au>
References: <20100215181335.f53ad8a0.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Feb 2010 14:38:04 -0700
X-Google-Sender-Auth: e426be9afc1f19fe
Message-ID: <fa686aa41002161338u25e58cc5m74e4b3c6e39b584b@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the 
	microblaze tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <michal.simek@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:13 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> arch/microblaze/include/asm/prom.h between commit
> 8d0fd5d72f5bcc597427afd73c6d5ba97fe4780f ("microblaze: Enable PCI,
> missing files") from the microblaze tree and commit
> df0edeb59eb559be0bee53452fda2f5cc0ae133f ("of: remove undefined
> request_OF_resource & release_OF_resource") from the devicetree tree.
>
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Michal, with respect to the current ongoing discussion, I hope you're
not planning on merging the microblaze PCI patches when Linus opens
the merge window.

g.
