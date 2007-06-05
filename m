Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbXFEPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbXFEPRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764763AbXFEPQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:16:58 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:49427 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764777AbXFEPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:16:57 -0400
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <20070602161337.46f267da.randy.dunlap@oracle.com>
References: <46600F1C.5000302@googlemail.com>
	 <20070602161337.46f267da.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 05 Jun 2007 10:16:45 -0500
Message-Id: <1181056605.3668.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-02 at 16:13 -0700, Randy Dunlap wrote:
> On Fri, 01 Jun 2007 14:20:44 +0200 Michal Piotrowski wrote:
> 
> > Hi all,
> > 
> > Here is a list of some known regressions in 2.6.22-rc3.
> > 
> > Feel free to add new regressions/remove fixed etc.
> > http://kernelnewbies.org/known_regressions
> > 
> > 
> > Unclassified
> > 
> > Subject    : build failed in function `vic_sys_interrupt'
> > References : http://lkml.org/lkml/2007/5/31/227
> > Submitter  : Toralf Förster <toralf.foerster@gmx.de>
> > Status     : Unknown
> 
> I probably wouldn't call a randconfig build problem a regression.
> 
> James, does Voyager support SMP=n now?

No, this is a longstanding bug that I keep meaning to find time to fix.

James


