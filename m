Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYJGNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYJGNmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJGNme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:42:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59985 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040AbYJGNmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:42:33 -0400
Date: Tue, 7 Oct 2008 15:42:23 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
Subject: Re: [Bug 10797] Battery is drained after poweroff
Message-ID: <20081007134223.GA1592@ucw.cz>
References: <48E9F388.8040203@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E9F388.8040203@diamondcut.com.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-10-06 08:16:24, Renato S. Yamane wrote:
> Hi,
> 
> Can someone help us with this bug?
> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> 
> Same problem is reported in Ubuntu:
> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
> 
> This is not a hardware problem, because if the same laptop is poweroff
> by Windows, battery charge don't change.

...and it is not linux problem because it works okay on my thinkpad. See? 

> And, if I suspend to ram/disk BEFORE poweroff, battery charge don't
> change (suspend to ram/disk --> WakeUp --> Poweroff).

Which machine is that? Can you find out which device eats power? (It
should be warm).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
