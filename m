Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbXJXSWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbXJXSWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbXJXSV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:21:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41229 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbXJXSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:21:57 -0400
Date: Wed, 24 Oct 2007 20:22:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/power/disk.c: make code static
Message-ID: <20071024182205.GB5093@elf.ucw.cz>
References: <20071024162342.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162342.GU30533@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-10-24 18:23:42, Adrian Bunk wrote:
> resume_file[] and create_image() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
