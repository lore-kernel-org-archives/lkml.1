Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZALUYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZALUYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbZALUYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:24:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58974 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbZALUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:24:31 -0500
Date: Mon, 12 Jan 2009 21:26:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] w35und: merge wbhal_s.h and wbhal_f.h header files
Message-ID: <20090112202628.GC2299@elf.ucw.cz>
References: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-12 18:03:13, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> No need to keep function definitions separate from the rest so unify wbhal_s.h
> and wbhal_f.h header files.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
