Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788Ab0AJXCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0AJXCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630Ab0AJXCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:02:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0AJXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:02:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #14899] reiserfs: inconsistent lock state
Date: Mon, 11 Jan 2010 00:02:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.vd.qNlSLB@chimera> <20100110224914.GB5039@nowhere>
In-Reply-To: <20100110224914.GB5039@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001110002.46621.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 January 2010, Frederic Weisbecker wrote:
> On Sun, Jan 10, 2010 at 11:32:53PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14899
> > Subject		: reiserfs: inconsistent lock state
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-12-11 22:06 (31 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126056920702515&w=4
> > Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/67256/
> > 		  http://patchwork.kernel.org/patch/67257/
> 
> 
> 
> The fix have been pulled upstream. Would be nice to have Alexander
> confirmation that it's really fixed though.

Well, I guess he can reopen the bug if the problem is still there.

Closed.

Rafael
