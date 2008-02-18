Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbYBRTs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbYBRTs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYBRTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:48:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52660 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760443AbYBRTsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:48:45 -0500
Date: Mon, 18 Feb 2008 20:49:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Message-ID: <20080218194904.GA7115@elf.ucw.cz>
References: <20080218002815.GA4612@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218002815.GA4612@dose.home.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-18 01:28:15, Tino Keitel wrote:
> Hi folks,
> 
> with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> message on the console is "Suspending console(s)". I also tried some
> other versions after 2.6.24, all of them fail with this hang.

Try adding 'no_console_suspend' to kernel command line.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
