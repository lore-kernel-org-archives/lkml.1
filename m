Return-Path: <linux-kernel-owner+w=401wt.eu-S937568AbXGUJDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937568AbXGUJDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXGUJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:03:23 -0400
Received: from mx1.suse.de ([195.135.220.2]:45225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXGUJDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:03:21 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oleg Verych <olecom@flower.upol.cz>, Sam Ravnborg <sam@ravnborg.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target
References: <11846813423231-git-send-email-sam@ravnborg.org>
	<11846813432249-git-send-email-sam@ravnborg.org>
	<1184681343297-git-send-email-sam@ravnborg.org>
	<11846813432231-git-send-email-sam@ravnborg.org>
	<1184681343423-git-send-email-sam@ravnborg.org>
	<11846813432234-git-send-email-sam@ravnborg.org>
	<11846813441521-git-send-email-sam@ravnborg.org>
	<11846813443387-git-send-email-sam@ravnborg.org>
	<1184681344594-git-send-email-sam@ravnborg.org>
	<11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-g
	it-send-email-sam@ravnborg.org>
	<11846813443187-git-send-email-sam@ravnborg.org> <11846813
	444171-git-send-email-sam@ravnborg.org>
	<1184681344985-git-send-email-sam@ravnborg.org>
	<11846813442810-git-send-email-sam@ravnborg.org>
	<118468134441-git-send-email-sam@ravnborg.org>
	<11846813441741-git-send-email-sam@ravnborg.org>
	<1184681344376-git-send-email-sam@ravnborg.org>
	<E1ICAEU-0005an-5F@flower> <jewswu9ncf.fsf@sykes.suse.de>
	<Pine.LNX.4.64.0707211038150.21737@fbirervta.pbzchgretzou.qr>
X-Yow: I always have fun because I'm out of my mind!!!
Date: Sat, 21 Jul 2007 11:03:19 +0200
In-Reply-To: <Pine.LNX.4.64.0707211038150.21737@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Sat\, 21 Jul 2007 10\:39\:40 +0200 \(CEST\)")
Message-ID: <jer6n29lig.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> Uhm, would not it be easier to just use 's/\b__user\b//g' ?

\b is not POSIX.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
