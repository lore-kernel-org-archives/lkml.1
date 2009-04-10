Return-Path: <linux-kernel-owner+w=401wt.eu-S939278AbZDJRyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939278AbZDJRyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765888AbZDJRyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:54:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49385 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZDJRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:54:19 -0400
Date: Fri, 10 Apr 2009 19:57:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Message-ID: <20090410175723.GA20983@elf.ucw.cz>
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-10 02:03:13, Theodore Ts'o wrote:
> Hi, has anyone else noticed that suspend-to-ram seems to have gotten
> broken in 2.6.30-rc1, sometime during last half of the merge window?
> I've been at a conference all of this past week, so I haven't had time
> to bisect it yet.  I was wondering if anyone else had noticed and
> figured out what was going wrong.  Symptoms are that the suspend "moon"
> starts flashing and the system never manages to put itself to sleep.  

s2ram seems to work ok for me on thinkpad x60... Maybe it is
hw-dependend, mut maybe it is just a kernel config...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
