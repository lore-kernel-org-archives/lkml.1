Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbXHHShs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbXHHShs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXHHShl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:37:41 -0400
Received: from mail.trixing.net ([87.230.125.58]:51684 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXHHShk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:37:40 -0400
Message-ID: <46BA0D77.6070007@l4x.org>
Date: Wed, 08 Aug 2007 20:37:43 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
References: <46B9F948.3090205@googlemail.com>
In-Reply-To: <46B9F948.3090205@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [1/3] 2.6.23-rc2: known regressions v2
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Unclassified
> 
> Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> References      : http://lkml.org/lkml/2007/8/6/43
> Last known good : ?

alpha: 2.6.22-git8
xtensa: 2.6.22-git6

> Submitter       : Jan Dittmer <jdi@l4x.org>
> Caused-By       : ?
> Handled-By      : ?

xtensa: Christian Zankel, has patches
alpha: unhandled, I'd blame the (slub,slab,reclaim,...)-mm changes
which went in on 2007-07-17.

> Status          : unknown


Jan
