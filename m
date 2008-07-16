Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYGPVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYGPVKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYGPVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:10:34 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:38151 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYGPVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:10:34 -0400
Date: Wed, 16 Jul 2008 23:10:30 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: request: via velocity and tg3 help
Message-ID: <20080716211030.GA27803@electric-eye.fr.zoreil.com>
References: <cccedfc60807151733n1c204c73ya4878bc03cba2e26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cccedfc60807151733n1c204c73ya4878bc03cba2e26@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Nelson <jnelson@jamponi.net> :
> I have a pair (each) of VIA Velocity and Broadcom (Altima) gig-e NICs.
> They've never worked worth a damn. Only with 2.6.25.5 (and later) does
> the VIA not kernel oops on boot, but neither one of them works
> correctly, and things go downhill even faster when jumbo frames get
> involved. They are both OK in 100-mbit, but in gig-e nearly useless. I
> am willing to personally ship one or both cards to parties interested
> in making them work better. I also have a single RTL8169-based card
> which works OK but not great, and I may be willing to do the same
> there. The only gig-e NICs I have are NVidia (Marvell) MCP55 which, at
> least as of 2.6.25.9, work great - I'm easily able to sustain 112MB/s
> with 1500byte frames and a non-jumbo-frame capable Intel NIC.

Can you redirect to netdev@vger.kernel.org and describe more specifically
in what way the r8169 does not match your expectations ? Memory allocation
failures with jumbo frames ?

-- 
Ueimor
