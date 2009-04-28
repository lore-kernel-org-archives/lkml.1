Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbZD1Rmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbZD1Rmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbZD1RmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:42:21 -0400
Received: from dns2.vpop.net ([216.193.240.3]:2689 "EHLO thorin.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762622AbZD1RmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:42:13 -0400
Message-ID: <49F73899.2040701@vpop.net>
Date: Tue, 28 Apr 2009 10:10:49 -0700
From: Matt Reimer <mreimer@vpop.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 1/3] w1: ds2760_battery: cleanups in ds2760_battery_probe()
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> Removed struct ds2760_platform_data which wasn't defined anywhere.
> Indentation cleanups.
>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>   
Ack.

Matt
