Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYC1K60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYC1K60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYC1K6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:58:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57704 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYC1K6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:58:18 -0400
Date: Fri, 28 Mar 2008 11:58:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Rodney Lorrimar <rodney@rodney.id.au>, jikos@suse.cz
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>
Subject: Re: [PATCH] Input: adbhid - fix capslock key state after suspend
Message-ID: <20080328105855.GA1686@elf.ucw.cz>
References: <20080328001556.GA30148@solaria.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328001556.GA30148@solaria.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-28 01:15:56, Rodney Lorrimar wrote:
> If the adbhid module parameter restore_capslock_events is used,
> sometimes capslock will get stuck down after resuming.

Hmmm, why does that need to be a parameter? I mean... can we just do
the right thing?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
