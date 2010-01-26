Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783Ab0AZVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0AZVqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733Ab0AZVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:46:51 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34693 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0AZVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:46:50 -0500
Date: Tue, 26 Jan 2010 22:46:47 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Stanislav Brabec <utx@penguin.cz>
Subject: Re: How to write driver that needs to call another driver?
Message-ID: <20100126214647.GA5616@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264540265.2411.20.camel@utx.utx.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

dito here: I've got a nice ELV USB2I2C adapter which has a cp210x USB2serial
chip (i.e., drivers/usb/serial/cp210x.c) and is a definite I2C stack
driver candidate (i.e., drivers/i2c/xxx).

So???

Although I suspect that our two cases might be unrelated since yours
seems like lots of platform data magic and mine might perhaps be
solvable via some tty layer magic.

Sorry for the disruption ;)

Andreas Mohr
