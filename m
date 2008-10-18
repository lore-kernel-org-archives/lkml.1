Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYJRTZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYJRTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYJRTNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:13:16 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:37578 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763AbYJRTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:13:15 -0400
Message-ID: <48FA3545.3030102@superbug.co.uk>
Date: Sat, 18 Oct 2008 20:13:09 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
In-Reply-To: <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse wrote:
> 
> Many of the reports seem to be related in time to a graphics crash, no one 
> has been able to give us more detail about how to reproduce.  We NEED HELP 
> reproducing this.  Steps, hints, anything.  We are trying rebooting, 
> suspending, opensuse, fedora, ubuntu, and several hardware platforms, etc.
> 

I would suspect the ipv6 module instead of the graphics. It has a number
of bugs in it. I am just mentioning it in case it helps.

Kind Regards

James



