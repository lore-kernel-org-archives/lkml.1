Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbYBHIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbYBHIlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbYBHIlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:41:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:47937 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbYBHIlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:41:05 -0500
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other
	goodies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 19:40:43 +1100
Message-Id: <1202460043.7079.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> - couple of fixes and preparatory patches
> 
> - rework of PowerMac media-bay support ([un]register IDE devices instead of
>   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]

Interesting... I was thinking about doing a full remove of the device at
a higher level instead but I suppose what you propose is easier.

I'll have a look & test next week hopefully.

Ben.


