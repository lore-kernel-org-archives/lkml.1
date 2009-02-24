Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbZBXUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbZBXUwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZBXUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:52:31 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45575 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZBXUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:52:30 -0500
Date: Tue, 24 Feb 2009 21:52:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend regression with 2.6.29-rc
Message-ID: <20090224205227.GA17485@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224190850.GA27800@dose.home.local>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What, no_console_suspend of course ;)

Needless to say I'm also stuck as always, waiting for -rc resume regressions
(due to i945 I think, -rc4 currently) to vanish
(I believe -rc6 wouldn't fix it yet, may try -rc7 then).
How many suspend/resume regression reports did we have in 2.6.29-rc? 5? 6? 7?
When did I first have 30+ working suspend/resumes on a desktop PC? 2001?
2000? 1999?
I'm not entirely sure whether I can achieve similar reliability
on a convincing number of desktops 10 years later...

Andreas Mohr
