Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYDAMnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYDAMnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYDAMnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:43:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55631 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYDAMnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:43:13 -0400
Date: Tue, 1 Apr 2008 14:43:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: bluetooth vs. suspend problems: testers wanted
Message-ID: <20080401124351.GA13221@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

bluetooth likes to kill the machine with s2ram cycle (in a nasty way
-- it actually corrupts memory). The bug has been there forever, and I
think I'm close to a fix. ... I would need few testers ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
