Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZCCTzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZCCTzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZCCTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:55:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZCCTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:55:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [Bug #12395] 2.6.28-rc9: oprofile regression
Date: Tue, 3 Mar 2009 20:55:23 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Tim Blechmann <tim@klingt.org>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.Lh.4zzoJB@chimera> <20090303113218.GE10085@erda.amd.com>
In-Reply-To: <20090303113218.GE10085@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032055.23969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Robert Richter wrote:
> Fix upstream in tip/x86/urgent:
> 
> 780eef9492b16a1543a3b2ae9f9526a735fc9856

URL, please?

Rafael

 
> On 23.02.09 23:03:00, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12395
> > Subject		: 2.6.28-rc9: oprofile regression
> > Submitter	: Tim Blechmann <tim@klingt.org>
> > Date		: 2008-12-21 14:23 (65 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> > References	: http://marc.info/?l=linux-kernel&m=122986946614791&w=4
> > Handled-By	: Andi Kleen <ak@linux.intel.com>
