Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZFMSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZFMSml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZFMSmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 14:42:33 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:58606 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFMSmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 14:42:33 -0400
Message-ID: <4A33F311.9060204@mnementh.co.uk>
Date: Sat, 13 Jun 2009 19:42:25 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 0/7] ASIC3 support for tmio_mmc
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com> <20090613135830.6246d0b8@mjolnir.ossman.eu>
In-Reply-To: <20090613135830.6246d0b8@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:

> I've queued up everything except patch 7 as I haven't seen Ian's
> response on that yet.

Is that using my replacement for patch 6 ? I didnt ack that one since 
(whilst correct) My solution is simpler and fixes another bug as well.

Patch 7 is Acked-by me now that Philipp has explained the idea behind it.
