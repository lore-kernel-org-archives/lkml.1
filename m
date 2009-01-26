Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394AbZAZAUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbZAZAUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 19:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZAZAUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 19:20:31 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:11439 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZAZAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:20:31 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <497D01CA.9040601@tremplin-utc.net>
Date: Mon, 26 Jan 2009 01:20:26 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: [PATCH 0/4] lis3lv02d: add support for various laptop models
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a series of patches to add knowledge about the axes of various
HP laptops supported by lis3lv02d/hp_accel, received from owners of
those laptops. The laptops are already detected, but these patches allow
to standardize the reported data with the physical movement of the laptop.

These are safe patches, allowing better hardware support, so it would be
great if they were accepted for 2.6.29 :-)

See you,
Eric
