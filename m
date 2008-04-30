Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbYD3IoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbYD3IoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYD3IoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:44:00 -0400
Received: from rekin23.go2.pl ([193.17.41.16]:56400 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbYD3In7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:43:59 -0400
Subject: =?UTF-8?Q?Re:_Re:_Fwd:_[PATCH]_[MMC]_fix_clock_problem_in_PXA255/270?=
From: =?UTF-8?Q?Tadeusz_Gozdek?= <linux_fan@o2.pl>
To: =?UTF-8?Q?_Pierre__Ossman?= <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
In-Reply-To: <20080429182208.70e1053e@mjolnir.drzeus.cx>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl> <20080429113946.1ba93ef5@mjolnir.drzeus.cx>
	<60c632a5.15d4db9c.4816f8d4.b398b@o2.pl> <20080429182208.70e1053e@mjolnir.drzeus.cx>
Mime-Version: 1.0
Message-ID: <23a6d1f0.1cb4bd03.4818314f.41f4@o2.pl>
Date: Wed, 30 Apr 2008 10:43:59 +0200
X-Originator: 62.225.75.172
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Different in what regard? Or are you referring to the already present
> clock fudging in the driver?
I mean already present clock... but it looks only I have problem with this using Linux. 
I've checked other OS with the same board and it switch off the SD clock after complete the data transfer and switching the SD to idle mode.

> This is a project that has been popping up now and then, but the big
> thing that is lacking is someone who is able to actually measure if
> there is a power gain from this. I don't want to add a lot of code that
> isn't doing any good, so I want hard numbers.
OK OK. I understand. :)
I check some devices with the SD and Linux inside and all of them had modified driver which is able to switch off the clock :)
Thus the "persistent clock" problem exist, but nobody say about it :)

Thank you for all explanations.
