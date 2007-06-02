Return-Path: <linux-kernel-owner+w=401wt.eu-S1763675AbXFBXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbXFBXPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761892AbXFBXPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:15:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63955 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064AbXFBXPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:15:32 -0400
Date: Sat, 2 Jun 2007 16:13:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       jejb <james.bottomley@steeleye.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
Message-Id: <20070602161337.46f267da.randy.dunlap@oracle.com>
In-Reply-To: <46600F1C.5000302@googlemail.com>
References: <46600F1C.5000302@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 14:20:44 +0200 Michal Piotrowski wrote:

> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc3.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> Unclassified
> 
> Subject    : build failed in function `vic_sys_interrupt'
> References : http://lkml.org/lkml/2007/5/31/227
> Submitter  : Toralf Förster <toralf.foerster@gmx.de>
> Status     : Unknown

I probably wouldn't call a randconfig build problem a regression.

James, does Voyager support SMP=n now?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
