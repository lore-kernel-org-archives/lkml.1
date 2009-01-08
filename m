Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZAHKId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZAHKId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZAHKIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:08:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZAHKIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:08:24 -0500
Date: Thu, 8 Jan 2009 11:10:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] w35und: remove useless macro from common.h
Message-ID: <20090108101023.GB7577@elf.ucw.cz>
References: <Pine.LNX.4.64.0901081130530.15334@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901081130530.15334@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-08 11:31:28, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The DebugUsbdStatusInformation macro doesn't do anything useful so remove the
> definition and the two users of it from driver code.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
