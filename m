Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYC2SOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYC2SOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYC2SNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:13:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbYC2SNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:13:53 -0400
From: Andreas Schwab <schwab@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com>
	<18414.31274.514325.238985@harpo.it.uu.se>
X-Yow: NATHAN...  your PARENTS were in a CARCRASH!!
 They're VOIDED - They COLLAPSED
 They had no CHAINSAWS...  They had no MONEY MACHINES...
 They did PILLS in SKIMPY GRASS SKIRTS...
 Nathan, I EMULATED them...  but they were OFF-KEY...
Date: Sat, 29 Mar 2008 19:13:52 +0100
In-Reply-To: <18414.31274.514325.238985@harpo.it.uu.se> (Mikael Pettersson's
	message of "Sat\, 29 Mar 2008 18\:19\:38 +0100")
Message-ID: <jezlshe6u7.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> In a language with strict a comma-as-separator rule you can
> get this benefit by placing the comma before new items rather
> than after existing items:
>
> enum {	FOO
> 	,FIE
> 	,FUM
> };
>
> but luckily C doesn't need this perversion.

Only since C99 (but GNU C never needed it either).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
