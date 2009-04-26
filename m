Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZDZPPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZDZPPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZDZPOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:14:50 -0400
Received: from pearlgates.net ([82.92.180.13]:44113 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZDZPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:14:49 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 11:14:49 EDT
Date: Sun, 26 Apr 2009 17:07:29 +0200
From: Angel <angel@pearlgates.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI
 enabled
Message-Id: <20090426170729.3489b482.angel@pearlgates.net>
In-Reply-To: <egHshlwQQFE.A.ITD.zpE9JB@chimera>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	<egHshlwQQFE.A.ITD.zpE9JB@chimera>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).

I've tested with kernel 2.6.29.1. The problem still persists. While everything works fine with 2.6.28 or lower, starting X (both 1.3 and 1.5) with DRI enabled on a 2.6.29 kernel results in a garbled screen and unresponsive keyboard.


-- 
Angel <angel@pearlgates.net>
