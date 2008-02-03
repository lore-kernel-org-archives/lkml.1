Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYBCKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYBCKs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 05:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYBCKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 05:48:22 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:60243 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYBCKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 05:48:21 -0500
Message-ID: <47A59AF4.9050204@panasas.com>
Date: Sun, 03 Feb 2008 12:44:04 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25 - old NCR53C9x driver
References: <1201829922.23523.68.camel@brick>
In-Reply-To: <1201829922.23523.68.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2008 at 3:38 +0200, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> The following are entries in feature-removal-schedule.txt that have
> come due.  Please change the subject when replying to specific items.
> 
> Where I've gotten responses from the named person in the file, I've
> included their comment.
> 
> ---------------------------
> 
> What:	old NCR53C9x driver
> When:	October 2007
> Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> 	driver can be ported over almost trivially.
> Who:	David Miller <davem@davemloft.net>
> 	Christoph Hellwig <hch@lst.de>
> 
> DaveM: Likely one more release with this, perhaps delete 2.6.26
> ---------------------------
This has been done and is currently in scsi-misc awaiting for a pull.
