Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZEKMdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZEKMdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZEKMdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:33:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:55050 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbZEKMdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:33:09 -0400
Date: Mon, 11 May 2009 08:33:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.1: hda-intel: IRQ timing workaround is activated for card
Message-ID: <alpine.DEB.2.00.0905110830520.30983@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Kernel: 2.6.29.1
Distribution: Debian Testing

Once and awhile I see this:

[2916854.550302] hda-intel: IRQ timing workaround is activated for card #0.
Suggest a bigger bdl_pos_adj.

I do not recall seeing it often (if at all < 2.6.27-8) is this anything to
be worried about?

Please cc me as I am not on the list.

Justin.
