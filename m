Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYCCOqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYCCOqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYCCOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37171 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbYCCOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:57 -0500
Date: Mon, 3 Mar 2008 15:14:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rick van Rein <rick@vanrein.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080303141438.GD12606@elf.ucw.cz>
References: <20080302134221.GA25196@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302134221.GA25196@phantom.vanrein.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is the latest version of the BadRAM patch, which makes it possible to
> run Linux on broken memory.  The patch supports the use of a lesser grade
> of memory, which could be marketed more cheaply and which would thereby
> decrease the environmental stress caused by the process of (memory) chip
> manufacturing.

What is wrong with mem=exactmap?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
