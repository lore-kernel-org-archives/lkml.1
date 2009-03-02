Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZCBPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZCBPJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZCBPJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:09:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36511 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZCBPJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:09:09 -0500
Date: Mon, 2 Mar 2009 16:11:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>, vbotka@suse.cz
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH 5/5] lis3: SPI transport layer
Message-ID: <20090302151153.GN2527@elf.ucw.cz>
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de> <1236004310-29196-5-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236004310-29196-5-git-send-email-daniel@caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-02 15:31:50, Daniel Mack wrote:
> Make use of the new abstraction layer and add a new transport layer for
> spi. Works fine on a PXA based board.

Looks ok to me, and proves that previous patch was sane.

> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

Vlado, could you test the compelete series?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
