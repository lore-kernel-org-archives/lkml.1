Return-Path: <linux-kernel-owner+w=401wt.eu-S1946669AbXBQMQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946669AbXBQMQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946651AbXBQMQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:16:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:41715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965219AbXBQMQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:16:10 -0500
From: Andreas Schwab <schwab@suse.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: exporting LANG=C (Re: [PATCH] override build timestamp)
References: <20070216215213.GA10732@aepfle.de> <E1HIGE5-0003WZ-Ew@flower>
	<20070217115115.GA17401@aepfle.de>
X-Yow: FISH-NET-FISH-NET-FISH-NET-FISH-NET-FISH!!
Date: Sat, 17 Feb 2007 13:15:59 +0100
In-Reply-To: <20070217115115.GA17401@aepfle.de> (Olaf Hering's message of
	"Sat, 17 Feb 2007 12:51:15 +0100")
Message-ID: <je3b55x9mo.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering <olaf@aepfle.de> writes:

> But we better build the whole kernel with LC_ALL=C LANG=C.

If you have LC_ALL=C you don't need LANG=C.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
