Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYKBQkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYKBQkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYKBQkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:40:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52766 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753681AbYKBQkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:40:04 -0500
Date: Sun, 2 Nov 2008 17:39:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: how much license information inside the kernel ?
Message-ID: <20081102163956.GA1442@ucw.cz>
References: <488434293@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488434293@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 11:54:57, devzero@web.de wrote:
> hi, 
> 
> i found that there is a LOT of repeating licensing information in the kernel.
> 
> for me, 
> 
> find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU General Public License|Free Software Foundation|version 2 of the License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A PARTICULAR"
> 
> gives a file sized ~3.5M

Now gzip it :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
