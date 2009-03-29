Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZC2IcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZC2IcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZC2IcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:32:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3094 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZC2IcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:32:04 -0400
Date: Sun, 29 Mar 2009 10:31:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, mchehab@infradead.org,
       linux@brodo.de, hch@lst.de, arjan@linux.intel.com, kay.sievers@suse.de,
       rui.zhang@intel.com, len.brown@intel.com, htejun@gmail.com,
       jengelh@computergmbh.de, Michael Buesch <mb@bu3sch.de>,
       gcosta@redhat.com, jirislaby@gmail.com, rene.herman@gmail.com,
       ole@ans.pl, tglx@linutronix.de
Subject: Re: feature-removal-schedule.txt updated ??
Message-ID: <20090329103144.15091e79@hyperion.delvare>
In-Reply-To: <49CEC796.5040801@gmail.com>
References: <49AF11AB.8040605@gmail.com>
	<49CEC796.5040801@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xose,

On Sun, 29 Mar 2009 01:57:58 +0100, Xose Vazquez Perez wrote:
> Xose Vazquez Perez wrote:
> 
> > code is still there or file is not updated ?
> > 
> > $ grep ^When  Documentation/feature-removal-schedule.txt | egrep -v "2009|2010|2.6.3[0-9]"
> > When:   2.6.29
> > When:   July 2007
> > When:   December 2008
> > When:   November 2005
> > When:   August 2006
> > When:   before 2.6.19
> > When:   October 2008
> > When:   July 2008
> > When:   August 2007
> > When:   February 2008
> > When: Dec 2008
> > When:   July 2008
> > When:   2.6.27
> > When:   2.6.29
> > When:   After the only user (hal) has seen a release with the patches
> > When: 2.6.29
> 
> today only ONE was fixed!!

This is all not very constructive. For one thing the merge window is
still open, so there are reasonable chances that more entries will be
removed in the next 9 days.

For another, flooding people that way isn't going to fix anything. If
you really want the situation to improve, you have to look at offending
entries individually, contact the responsible person individually, ask
why the entry is still there, and then send a patch removing or
updating it if needs be. This is constructive. Yelling "there are
out-of-date entries in Documentation/feature-removal-schedule.txt" is
not.

In other words, if you are sufficiently bothered by the current
situation and want it to change, then work on it yourself, on your own
time. We aren't your slaves, and we don't owe you anything.

Thanks,
-- 
Jean Delvare
