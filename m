Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZETHyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZETHyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZETHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:54:23 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59045 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZETHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:54:22 -0400
X-Auth-Info: LPdrRDWTTZqmVspe/Qv7T+p4LnS/Usqi5wdYIf9qaK8=
Message-ID: <4A13B72B.5070206@grandegger.com>
Date: Wed, 20 May 2009 09:54:19 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 0/2] iproute2: Support for CAN network devices
References: <20090512094248.439786706@denx.de>
In-Reply-To: <20090512094248.439786706@denx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Grandegger wrote:
> Hello,
> 
> here are the patches for the "ip" program of the iproute2 utility
> suite adding support for CAN netlinks.
> 
>   1/2) iproute2: Fixes an issue with cross-compilation
>   2/2) iproute2: Support for the CAN netlink
> 
> The first patch is required to get it cross-compiled.
> 
> The patches are based on v2 of the patch series for the Linux kernel
> with the subject:
> 
>   [PATCH v2 0/7] can: CAN network device driver interface and drivers
> 
> posted a few minutes ago:
> 
>   http://marc.info/?l=linux-netdev&m=124212048701347&w=2
> 
> Please consider these patches for inclusion when the Linux kernel
> patches have been accepted.

The mentioned Socket-CAN kernel patches including netlink support have
been accepted in the meantime, see:
http://marc.info/?l=linux-netdev&m=124268656617653&w=2

Thanks,

Wolfgang.

