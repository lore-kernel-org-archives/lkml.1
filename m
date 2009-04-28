Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZD1RnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZD1RnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbZD1Rmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:42:50 -0400
Received: from dns2.vpop.net ([216.193.240.3]:2693 "EHLO thorin.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbZD1RmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:42:13 -0400
Message-ID: <49F738BB.5070103@vpop.net>
Date: Tue, 28 Apr 2009 10:11:23 -0700
From: Matt Reimer <mreimer@vpop.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 3/3] w1: ds2760_battery: add support for sleep mode feature
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de> <1240908902-24646-2-git-send-email-daniel@caiaq.de> <1240908902-24646-3-git-send-email-daniel@caiaq.de>
In-Reply-To: <1240908902-24646-3-git-send-email-daniel@caiaq.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> This adds support for ds2760's sleep mode feature. With this feature
> enabled, the chip enters a deep sleep mode and disconnects from the
> battery when the w1 line is held down for more than 2 seconds.
>
> This new behaviour can be switched on and off using a new module
> parameter.
>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>   
Ack.

Matt
