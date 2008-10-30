Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYJ3RMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYJ3RMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYJ3RMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:12:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56051 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752965AbYJ3RMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:12:37 -0400
Date: Thu, 30 Oct 2008 18:12:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] w35und: #include cleanup
Message-ID: <20081030171228.GA1670@ucw.cz>
References: <Pine.LNX.4.64.0810301303580.6842@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810301303580.6842@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 13:04:29, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch moves #includes from sysdef.h and common.h to the files which
> actually need them. This makes the dependencies less complex and allows us to
> move code around much easily.
> 

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
