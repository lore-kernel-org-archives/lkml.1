Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXIHQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXIHQln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbXIHQle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:41:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbXIHQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:41:33 -0400
Subject: Re: [2/4] 2.6.23-rc5: known regressions v2
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net, Oliver Neukum <oliver@neukum.org>
In-Reply-To: <46E28351.8050900@googlemail.com>
References: <46E27DEF.7060109@googlemail.com>
	 <46E28351.8050900@googlemail.com>
Content-Type: text/plain
Date: Sat, 08 Sep 2007 11:41:23 -0500
Message-Id: <1189269683.6183.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 13:11 +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc5.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions

> FS
> 
> Subject         : umount triggers a warning in jfs and takes almost a minute
> References      : http://lkml.org/lkml/2007/9/4/73
> Last known good : ?
> Submitter       : Oliver Neukum <oliver@neukum.org>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

Is this a regression?

Oliver,
Have you been using jfs on this flash previously?  If so, what was the
most recent kernel that didn't have problems?

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

