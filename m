Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYDJP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYDJP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbYDJP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:28:28 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40471 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbYDJP21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:28:27 -0400
Date: Thu, 10 Apr 2008 11:28:27 -0400
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: LinuxPPS (RESUBMIT 3): the PPS Linux implementation.
Message-ID: <20080410152827.GE2160@csclub.uwaterloo.ca>
References: <1207840560-24015-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207840560-24015-1-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 05:15:53PM +0200, Rodolfo Giometti wrote:
> This patch set adds the PPS support into Linux.
> 
> PPS means "pulse per second" and its API is specified by RFC 2783
> (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
> 
> The code has been tested with the NTPD program
> (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
> antennae.

Thank you for keeping at this.  Great work.

-- 
Len Sorensen
