Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbYBOOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbYBOOnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYBOOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:43:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34209 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYBOOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:43:00 -0500
Date: Fri, 15 Feb 2008 15:42:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
In-Reply-To: <20080214162104.GA5347@ics.muni.cz>
Message-ID: <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
References: <20080214162104.GA5347@ics.muni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14 2008 17:21, Lukas Hejtmanek wrote:
>Hello,
>
>whom should I blame about disk schedulers?

Also consider
- DMA (e.g. only UDMA2 selected)
- aging disk
