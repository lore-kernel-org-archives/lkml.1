Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZALUUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZALUUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZALUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:19:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57941 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZALUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:19:57 -0500
Date: Mon, 12 Jan 2009 21:21:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wb35und: remove hw_data_t typedef
Message-ID: <20090112202139.GB2299@elf.ucw.cz>
References: <Pine.LNX.4.64.0901121802110.16815@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901121802110.16815@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-12 18:02:47, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As this typedef is used everywhere in the driver, remove it in a separate
> patch.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
