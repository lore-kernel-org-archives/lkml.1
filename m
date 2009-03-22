Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZCWP24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZCWP24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZCWP2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:28:46 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:13846 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZCWP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:28:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -13.397
Message-ID: <49C6CA44.5080405@tremplin-utc.net>
Date: Mon, 23 Mar 2009 00:31:16 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 5/5] lis3: SPI transport layer
References: <49AD8B0A.90901@tremplin-utc.net> <1236131099-8082-1-git-send-email-daniel@caiaq.de> <1236131099-8082-2-git-send-email-daniel@caiaq.de> <1236131099-8082-3-git-send-email-daniel@caiaq.de>
In-Reply-To: <1236131099-8082-3-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> Make use of the new abstraction layer and add a new transport layer for
> spi. Works fine on a PXA based board.
Tested with a HP laptop, no problem on this part.

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Eric

