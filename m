Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZDOJES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZDOJES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZDOJED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:04:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37017 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDOJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:04:01 -0400
Date: Wed, 15 Apr 2009 10:03:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Bill Gatliff <bgat@billgatliff.com>
Subject: Re: Linux 2.6.30-rc2: [PATCH] ARM OABI compatibility: fix build
	error
Message-ID: <20090415090307.GH6058@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain> <20090415083326.GA12921@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415083326.GA12921@traven>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:33:26AM +0200, Matthias Kaehlcke wrote:
> Building for ARM with CONFIG_OABI_COMPAT enabled fails due to a
> missing include:

Yes, lots of people have been whinging about this over the last six days,
but I'm only just catching up since returning from an Easter break.

Does anyone know /when/ this breakage happened, or even better what caused
it?
