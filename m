Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYF0MWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYF0MWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbYF0MUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:20:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2205 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761814AbYF0MUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:20:45 -0400
Date: Fri, 27 Jun 2008 14:20:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
Message-ID: <20080627122030.GB10359@ucw.cz>
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz> <4864D9AF.4030509@slax.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864D9AF.4030509@slax.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-27 14:14:39, Tomas M wrote:
> Well, I use LZMA particularly in squashfs, which is a replacement for cramfs at all.
> 
> Unfortunately even squashfs is not in kernel.

That's good enough reason. Push squashfs first, or in same series as
lzma.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
