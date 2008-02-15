Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbYBON7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbYBON7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYBON6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:58:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34791 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYBON6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:58:50 -0500
Date: Fri, 15 Feb 2008 06:58:48 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Greg KH <greg@kroah.com>, Rene Herman <rene.herman@keyaccess.nl>,
       bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
Message-ID: <20080215135848.GD7657@parisc-linux.org>
References: <20080213001506.GA13933@kroah.com> <47B24AB3.3040009@keyaccess.nl> <20080213044436.GB10101@kroah.com> <47B4777A.70400@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B4777A.70400@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:16:42PM -0500, Bill Davidsen wrote:
> There are any number of things you can do when the system is booted, but 
> the only thing you can do when the system won't boot is use kernel boot 
> options.

Greg's not removing your option to boot the system using an old kernel
to set up a new kernel properly ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
