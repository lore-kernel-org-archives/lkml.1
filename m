Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZDHJuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZDHJuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZDHJuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:50:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49843 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbZDHJuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:50:02 -0400
Date: Wed, 8 Apr 2009 11:53:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] w35und: replace switch error handling with gotos
	in wb35_hw_init()
Message-ID: <20090408095300.GB24848@elf.ucw.cz>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-08 11:13:56, Pekka Enberg wrote:
> Impact: cleanup
> 
> This patch replaces the switch-based error handling in wb35_hw_init()
> with regular gotos.

Acked-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
