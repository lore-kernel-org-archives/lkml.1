Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbZGYUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbZGYUsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZGYUsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:48:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51393 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGYUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:48:51 -0400
Date: Sat, 25 Jul 2009 22:48:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
       Christian Thaeter <ct@pipapo.org>
Subject: Re: [PATCH 2/2] hpfall: accept disk device to unload as argument
Message-ID: <20090725204838.GA2246@elf.ucw.cz>
References: <200907252055.16416.elendil@planet.nl> <200907252100.14175.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907252100.14175.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-07-25 21:00:12, Frans Pop wrote:
> Allows users who use an IDE driver for their disk to use hpfall without
> having to modify the source. By default /dev/sda is used.
> Suggested by Christian Thaeter in http://lkml.org/lkml/2009/3/25/505.
> 
> While we're add it, improve error message if opening /dev/freefall fails.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
