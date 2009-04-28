Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZD1M5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZD1M5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZD1M5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:57:14 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:46738 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbZD1M5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:57:13 -0400
Message-ID: <49F6FCE4.9080409@euromail.se>
Date: Tue, 28 Apr 2009 14:56:04 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Document the bcm5974 driver
References: <1240916817-18995-1-git-send-email-rydberg@euromail.se> <49F6ED54.7040200@wincor-nixdorf.com>
In-Reply-To: <49F6ED54.7040200@wincor-nixdorf.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1Lymr2-0001AC-4m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Lymr2-0001AC-4m f75647f948901eb9002c4a7544d7e801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What about skipping rmmod and modprobe by doing
> 	echo -n 9 > /sys/module/bcm5974/parameters/debug
> and
> 	echo -n 0 > /sys/module/bcm5974/parameters/debug
> ?

Much neater, I'll send a revised patch right away. Thanks!

Henrik

