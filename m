Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJUVeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJUVeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYJUVd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:33:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55244 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYJUVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:33:58 -0400
Date: Tue, 21 Oct 2008 23:35:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: module init cleanup
Message-ID: <20081021213537.GA12616@elf.ucw.cz>
References: <Pine.LNX.4.64.0810211300560.32317@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810211300560.32317@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-21 13:01:42, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch cleans up the module init functions a bit and removes the redundant
> device ID check from wb35_probe() function.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
