Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYJ2Vhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYJ2Vhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYJ2VhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:37:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46915 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYJ2VhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:37:20 -0400
Date: Wed, 29 Oct 2008 22:38:53 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] w35und: remove unused link status code
Message-ID: <20081029213853.GG1976@elf.ucw.cz>
References: <Pine.LNX.4.64.0810292011500.16596@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810292011500.16596@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-29 20:12:08, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The WBLINUX_ConnectStatus() and related code is not used anywhere so remove
> them from the driver.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

...and thanks a lot for all the cleanups!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
