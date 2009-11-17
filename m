Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZKQJTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZKQJTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZKQJTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:19:23 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47010 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZKQJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:19:19 -0500
Date: Tue, 17 Nov 2009 18:19:05 +0900
To: Minchan Kim <minchan.kim@gmail.com>, gg@gandalf.dynalias.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #14618] OOM killer, page fault
Message-ID: <20091117091905.GA23205@gandalf.dynalias.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.nXG.-SdALB@chimera>
 <28c262360911170040r4313ca2bs9716b9271946f082@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c262360911170040r4313ca2bs9716b9271946f082@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, Minchan Kim wrote:
> I think we can ignore this bug.

Agreed. It is so hard to reproduce, and might be some other reason for
that. 

> As I know, It happens very rarely. Norbert, right?

Yes definitely.

> So I think It would be better to ignore this bug
> until we can meet similar report again.

Agreed, please close or whatever.

In case I find a method to reproduce it more easily I will come back to
you.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
SMEARISARY (n.)
The correct name for a junior apprentice greengrocer whose main duty
is to arrange the fruit so that the bad side is underneath. From the
name of a character not in Dickens.
			--- Douglas Adams, The Meaning of Liff
