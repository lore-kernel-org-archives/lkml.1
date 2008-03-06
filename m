Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbYCFITb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbYCFITb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYCFITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:19:18 -0500
Received: from mx1.suse.de ([195.135.220.2]:53047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYCFITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:19:17 -0500
Date: Thu, 6 Mar 2008 09:19:15 +0100
From: Andi Kleen <ak@suse.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [JANITOR-PATCH] rtc: switch to unlocked_ioctl
Message-ID: <20080306081915.GH9021@bingen.suse.de>
References: <1204664803.5698.27.camel@brick> <47CDD3F9.7070801@gmail.com> <200803051116.45769.ak@suse.de> <20080306081658.GA21135@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306081658.GA21135@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 08:16:58AM +0000, Russell King wrote:
> On Wed, Mar 05, 2008 at 11:16:45AM +0100, Andi Kleen wrote:
> > One easy way to do that is to do an allyesconfig build once and
> > save the log
> 
> Don't bother.  As I keep saying and have been saying since the all*config
> targets were introduced, they're useless for ARM, because ARM is soo
> diverse.

It's more a white list for x86. Yes it would mean there will be no
such patches for ARM.

-Andi
