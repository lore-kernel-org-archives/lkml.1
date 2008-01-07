Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYAGTN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYAGTN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYAGTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:13:19 -0500
Received: from science.horizon.com ([192.35.100.1]:17428 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752373AbYAGTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:13:18 -0500
Date: 7 Jan 2008 14:13:13 -0500
Message-ID: <20080107191313.6972.qmail@science.horizon.com>
From: linux@horizon.com
To: davem@davemloft.net, linux@horizon.com
Subject: Re: 2.6.24-rc6 oops in net_tx_action
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com, shemminger@linux-foundation.org
In-Reply-To: <20080107.002342.10040673.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Thanks!  I got the patch from
>> http://marc.info/?l=linux-netdev&m=119756785219214
>> (Which didn't make it into -rc7; please fix!)
>> and am recompiling now.

> Jeff is busy so he's asked me to pick up the more important
> driver bug fixes that get posted.
>
> I'll push this around, thanks.

Much obliged.  It's only 11 hours of uptime, but no problems so far,
even trying abusive things like "ping -f -l64 -s8000".
