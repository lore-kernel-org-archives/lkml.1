Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXFCOw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXFCOw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXFCOpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:45:44 -0400
Received: from xenotime.net ([66.160.160.81]:33772 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756818AbXFCOpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:45:43 -0400
Date: Sun, 3 Jun 2007 07:45:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-Id: <20070603074552.430c3d02.rdunlap@xenotime.net>
In-Reply-To: <20070603142939.GW4095@ftp.linux.org.uk>
References: <20070603142450.GA4230@localhost.localdomain>
	<20070603142939.GW4095@ftp.linux.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 15:29:39 +0100 Al Viro wrote:

> On Sun, Jun 03, 2007 at 10:24:50PM +0800, WANG Cong wrote:
>   
> > +Do care when you use Lindent to indent your code, since it may use spaces
> > +instead of tabs before a goto label and it may also align the label in a
> > +wrong position. A goto label should be aligned in the column that is 8
> > +characters ahead of the statement just below this label. Please fix it manually
> > +if you find Lindent is wrong.
> 
> Lindent is wrong, but the style you are advocating is, at the very
> least, not universal.  Equally (if not more) common is putting label
> in column 1, period.  Regardless of indentation level of the statement
> following it.

ack Al's style.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
