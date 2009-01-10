Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZAJVUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZAJVUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZAJVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:19:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZAJVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:19:55 -0500
Date: Sat, 10 Jan 2009 22:21:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: nbd: trivial cleanups
Message-ID: <20090110212154.GA14631@elf.ucw.cz>
References: <20090109100622.GA3585@elf.ucw.cz> <496747A4.7090909@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496747A4.7090909@steeleye.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-09 07:48:36, Paul Clements wrote:
> Pavel Machek wrote:
>> Trivial cleanups for nbd: only the return -EIO one really changes
>> code, and I've verified all the callers (plus 0 == success, 1 == error
>> convention is really ugly).
>>
>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> Looks good

Does it mean I can add your acked-by and merge it through Andrew?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
