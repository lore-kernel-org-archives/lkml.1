Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYA0PpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYA0PpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYA0Po4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:44:56 -0500
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:39242 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYA0Poz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:44:55 -0500
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 1/2] dm-band: The I/O bandwidth controller: Source code  patch
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, ryov@valinux.co.jp,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
In-reply-To: <E1JHfjM-0003NV-BR@faramir.fjphome.nl>
References: <20080123.215350.193721890.ryov@valinux.co.jp> <20080123.215632.226773739.ryov@valinux.co.jp> <E1JHfjM-0003NV-BR@faramir.fjphome.nl>
Message-Id: <E1JJ9gj-0001SH-U2@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 27 Jan 2008 16:44:53 +0100
X-OriginalArrivalTime: 27 Jan 2008 15:44:54.0387 (UTC) FILETIME=[8FB12C30:01C860FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> The help should probably be a bit more verbose as this does not tell
> anybody much who has not already read the documentation.
> 
> Maybe something like:
> <snip>
> This device-mapper target allows to define how the
> available bandwith of a storage device should be
> shared between processes or cgroups.
> 
> Information on how to use dm-band is available in:
>    Documentation/device-mapper/band.txt
> </snip>

I just see in other Kconfig files that the last line should be:
   <file:Documentation/device-mapper/band.txt>.

Cheers,
FJP
