Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZEZXP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZEZXP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZEZXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:15:52 -0400
Received: from kroah.org ([198.145.64.141]:46300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZEZXPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:15:51 -0400
Date: Tue, 26 May 2009 15:14:52 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name
	to mount debugfs filesystem.
Message-ID: <20090526221452.GA26664@kroah.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com> <20090526205414.GA26016@kroah.com> <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 05:15:09PM -0400, Steven Rostedt wrote:
> All my scripts search /proc/mounts to find where debugfs is mounted, then 
> it uses that.

Good.

> Hmm, Not sure what packages in the distros use the default. I don't see 
> the debugfs in /etc/fstab in any of my machines.

It's in mine, I don't know what packages use it at the moment.

thanks,

greg k-h
