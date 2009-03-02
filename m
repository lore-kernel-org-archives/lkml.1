Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZCBOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZCBOz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZCBOzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:55:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49264 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZCBOzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:55:15 -0500
Date: Mon, 2 Mar 2009 15:57:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH 3/5] lis3: reorder functions to make forward decl
	obsolete
Message-ID: <20090302145754.GL2527@elf.ucw.cz>
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236004310-29196-3-git-send-email-daniel@caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-02 15:31:48, Daniel Mack wrote:
> moved lis3lv02d_init_device() down so that the forward declaration of
> lis3lv02d_add_fs() becomes unnecessary.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
