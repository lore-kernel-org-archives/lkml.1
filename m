Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYHCHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYHCHDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYHCHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:03:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37667 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYHCHDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:03:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
References: <m1mykyh2fu.fsf_-_@frodo.ebiederm.org>
	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com>
	<m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com>
	<20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org>
	<487D6A24.9070001@gmail.com> <20080717230857.GB28377@suse.de>
	<48808F79.7080607@gmail.com> <20080718184936.GA21343@suse.de>
Date: Sat, 02 Aug 2008 23:59:07 -0700
In-Reply-To: <20080718184936.GA21343@suse.de> (Greg KH's message of "Fri, 18
	Jul 2008 11:49:36 -0700")
Message-ID: <m1zlnu60uc.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0561]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support for device classes.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> I'll add it to my tree, and get it some testing in the next cycle of
> linux-next until 2.6.27 is out, and then if it's still looking good, go
> into .28.

Greg.  Where are we at with this?

I just looked at your tree and I don't perhaps I'm blind but I don't see
this patches, and it looks like you at least refreshed your patches
a day or two ago.

Eric

