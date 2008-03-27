Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbYC0PBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbYC0PBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYC0PBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:01:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59600 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbYC0PBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:01:03 -0400
Date: Thu, 27 Mar 2008 16:01:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: something wrong with ^C
Message-ID: <20080327150138.GC13553@elf.ucw.cz>
References: <20080327142814.GC13190@elf.ucw.cz> <47EBB4BC.7040509@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47EBB4BC.7040509@draigBrady.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-27 14:52:44, Pádraig Brady wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> > Is it just me, or does ^C take longer in 2.6.25?
> > 
> > Like... one second delay between pressing ^C and seeing any effect?
> 
> It can join Ctrl-\ on ubuntu so:
> https://bugs.launchpad.net/bugs/62511

No, I do not think I'm doing anything fancy with coredumps...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
