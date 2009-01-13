Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbZAMOe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbZAMOe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760769AbZAMOes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:34:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54572 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbZAMOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:34:47 -0500
Date: Tue, 13 Jan 2009 15:36:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090113143646.GB1983@elf.ucw.cz>
References: <20090113081316.GA2292@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113081316.GA2292@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 09:13:16, Pavel Machek wrote:
> Hi!
> 
> Just when I thought long merge window means less problems...
> 
> ...suspend seemed to work until last tuesday or so. Now it hanged two
> times; once so hard that power button powercycle did not result in
> booting machine. (thinkpad x60)
> 
> I'll do some more tests...

It resumes fine with CONFIG_SMP unset.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
