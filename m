Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZLHKex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZLHKex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZLHKev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:34:51 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37523 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZLHKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EyNmpJ6xr5rgpBPvq/O45BtNULOZHNG/00D8RNpuu9kZ6wUKfARAjt382carMurkcU
         fzYODL1YdeqzeF2ONRNu3kAM5Pdjh53FNZAPeibFfafyR7BTu7ukk6Dempr7+2z7AH3k
         Adpx2jfb87BetHXJ3f8v/A6WtQwrbMpIBnDOw=
Message-ID: <4B1E2BE4.20404@gmail.com>
Date: Tue, 08 Dec 2009 11:35:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-3.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: DRM/ttm: Unreachable code in ttm_bo_add_ttm
References: <4B1D68AD.2090409@gmail.com> <alpine.DEB.2.00.0912072328050.14943@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0912072328050.14943@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 12:28 AM, Dave Airlie wrote:
> From 447aeb907e417e0e837b4a4026d5081c88b6e8ca Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Tue, 8 Dec 2009 09:25:45 +1000
> Subject: [PATCH] drm/ttm: fix unreachable code.
> 
> None of the in-tree drivers use user objects yet so this wasn't hitting
> us.
> 
> Stanse found unreachable code in ttm_bo_add_ttm:
> http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=32&id=714#l238

Please don't use the link in changelog, it's only temporary. Well, it
will probably be there for months, but the changelog will be there forever.

Thanks.
