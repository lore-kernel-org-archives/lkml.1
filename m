Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYGPPfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYGPPfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYGPPfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:35:10 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:49192 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbYGPPfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:35:09 -0400
Date: Wed, 16 Jul 2008 17:35:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] Add module.h include to stacktrace.c.
Message-ID: <20080716153506.GD6377@osiris.boeblingen.de.ibm.com>
References: <20080711103925.GA20589@osiris.boeblingen.de.ibm.com> <20080716143033.GD25557@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716143033.GD25557@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:30:33PM +0300, Adrian Bunk wrote:
> Why was this patch ignored?
> 
> The build failures now made it into Linus' tree.
> 
> Stephen already fixed the powerpc one.
> s390 is still broken.
> And I just ran into this compile error on sh...

Dunno... I'm just going to add a patch to our tree.
