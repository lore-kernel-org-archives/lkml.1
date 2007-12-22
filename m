Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXLVSoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXLVSoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 13:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXLVSoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 13:44:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39417 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbXLVSoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 13:44:18 -0500
Date: Sat, 22 Dec 2007 19:43:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard D <richard@embunus.com>
Cc: "'Matthew Bloch'" <matthew@bytemark.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071222184309.GA31809@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <000a01c844af$8e76b910$ab642b30$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01c844af$8e76b910$ab642b30$@com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-22 21:00:11, Richard D wrote:
> I was thinking that by the time userspace is ready, the memory that can be
> tested will be less.

Which does not matter when you can test the rest using second
(kexec-ed) kernel, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
