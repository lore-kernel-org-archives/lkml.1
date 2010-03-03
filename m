Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0CCGzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:55:33 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44170 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754864Ab0CCGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:55:31 -0500
Date: Wed, 3 Mar 2010 07:55:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: dream: pmem: fix some code style issues
Message-ID: <20100303065530.GD25144@atrey.karlin.mff.cuni.cz>
References: <1267599191-10327-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267599191-10327-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like some braces {} deleted becouse
> are not necessary for a single statement blocks and to include KERN_
> facility level in the printk() functions.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
