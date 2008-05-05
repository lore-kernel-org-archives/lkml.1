Return-Path: <linux-kernel-owner+w=401wt.eu-S1761800AbYEEVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761800AbYEEVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYEEVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:31:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53325 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYEEVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:31:25 -0400
Date: Mon, 5 May 2008 23:32:14 +0200
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: driver now down to 16Kloc, and actually works a bit
Message-ID: <20080505213214.GC17657@elf.ucw.cz>
References: <20080505210138.GE7273@elf.ucw.cz> <1210021369.4181.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210021369.4181.43.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-05 23:02:49, Johannes Berg wrote:
> On Mon, 2008-05-05 at 23:01 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > Ok, code is still extremely ugly, but at least it uses softmac (and
> 
> why not mac80211? softmac has been deleted

It uses mac80211, or whatever softmac stack is present in
2.6.25. Sorry for confusion.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
