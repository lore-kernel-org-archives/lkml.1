Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYGMMhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYGMMhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 08:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYGMMho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 08:37:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4023 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752995AbYGMMho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 08:37:44 -0400
Date: Sat, 12 Jul 2008 15:32:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with resume from s2ram following hibernate
Message-ID: <20080712133236.GA14877@ucw.cz>
References: <9b2db90b0807100200h5e1eabaapada93d8e5cc3ec79@mail.gmail.com> <9b2db90b0807100202l53df9364tf36c5dfaf18bf1f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2db90b0807100202l53df9364tf36c5dfaf18bf1f5@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I am currently using kernel 2.6.25 (with Gentoo patches), and have had
> the problem ever since I managed to get suspend to disk working. One
> issue which might be related is that I boot my kernel with
> "acpi_serialize", as otherwise I get many acpi error messages.

Try vanilla 2.6.26-rc... we can't debug vendor kernels here.

> I'd really like to solve this issue, and am willing to invest time
> towards this. However, I have no idea where to begin. I'd appreciate
> any pointers / advice.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
