Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXDRU6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXDRU6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXDRU6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:58:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:54034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992617AbXDRU6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:58:05 -0400
From: Andreas Schwab <schwab@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stupid GIT question...
References: <20364.1176926921@turing-police.cc.vt.edu>
X-Yow: "DARK SHADOWS" is on!!  Hey, I think the VAMPIRE forgot his UMBRELLA!!
Date: Wed, 18 Apr 2007 22:58:01 +0200
In-Reply-To: <20364.1176926921@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Wed, 18 Apr 2007 16:08:41 -0400")
Message-ID: <jetzvdbdt2.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> What's the command to get a diff of "what I would merge if I said 'git pull'?"

$ git fetch
$ git diff master origin

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
