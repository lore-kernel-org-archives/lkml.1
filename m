Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbYKIOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbYKIOB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYKIOBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:01:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36867 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754838AbYKIOBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:01:46 -0500
Date: Sun, 9 Nov 2008 14:51:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc3] regression when switching TTY->X, input related?
Message-ID: <20081109135146.GB1730@ucw.cz>
References: <20081105220419.GA15685@pest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105220419.GA15685@pest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> I think this is a regression because it used to work with the 2.6.27
> kernel from Ubuntu. I'll try with a vanilla 2.6.27 but I had been

Yes, please try that. It is possible that ubuntu has some patches in
and that their userland depens on them...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
