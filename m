Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbXLLGr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbXLLGr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXLLGrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:47:49 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49897 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXLLGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:47:48 -0500
Date: Wed, 12 Dec 2007 07:47:31 +0100
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@qumranet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       hugh <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
Message-ID: <20071212064730.GI26785@gamma.logic.tuwien.ac.at>
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at> <200712102230.04342.rjw@sisk.pl> <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at> <475D37CE.8040602@qumranet.com> <20071210125938.GC25518@gamma.logic.tuwien.ac.at> <475D475A.8090007@qumranet.com> <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <1197285967.31440.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712102230.04342.rjw@sisk.pl> <475D475A.8090007@qumranet.com> <1197285967.31440.22.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Mo, 10 Dez 2007, Peter Zijlstra wrote:
> How reproducable is this? You make it sound like its easy to reproduce,

I tried and re-tried and re-tried to reproduce this, without success.
Sorry. 

I guess we can forget that one and assume that it was a strange
coincidence.

Sorry for the noise.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
PAPWORTH EVERARD (n.)
Technical term for the third take of an orgasm scene during the making
of a pornographic film.
			--- Douglas Adams, The Meaning of Liff
