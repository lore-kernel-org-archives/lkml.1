Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYAZNbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYAZNbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYAZNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:31:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48906 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYAZNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:31:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479B3615.9000903@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 14:31:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Ingo Molnar <mingo@elte.hu>, "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: using LKML for subsystem development
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de>            <479A8203.40804@s5r6.in-berlin.de> <8125.1201318113@turing-police.cc.vt.edu>
In-Reply-To: <8125.1201318113@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sat, 26 Jan 2008 01:42:43 +0100, Stefan Richter said:
> 
>> Even if you only look at the Subject: and number of postings in a
>> thread, how to judge whether there is a stability risk for the next -rc
>> in the making, without experience or personal interest in the domain?
> 
> My general rule of thumb is "if my laptop has one of those on it, I look
> at it more, even if I don't have the foggiest idea how it works".  Of
> course, this only works for threads with semi-sane Subject: headers....

Does your laptop have for example chained sg lists?  :-)
Or are BIDI(rectional SCSI commands) relevant to you?  (Not at all,
except if the eventual merge of the SCSI bidi will break something.)
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
