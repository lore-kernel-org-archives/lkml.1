Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYCaMaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYCaMaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYCaMaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:30:02 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYCaMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:30:00 -0400
Date: Mon, 31 Mar 2008 14:29:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
Message-ID: <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-03-27 15:55, Artem Bityutskiy wrote:
>
> here is a new flash file system developed by Nokia engineers with
> help of the University of Szeged. The new file-system is called
> UBIFS, which stands for UBI file system. UBI is the wear-leveling/
> bad-block handling/volume management layer which is already in
> mainline (see drivers/mtd/ubi).
>[...]

And how does it compare to logfs?
