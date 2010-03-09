Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0CIUOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:14:04 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:35780 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab0CIUN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:13:59 -0500
Date: Tue, 9 Mar 2010 13:13:58 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: Fixup broken chown tracking
Message-ID: <20100309201358.GG30462@obsidianresearch.com>
References: <20100309191127.GA30462@obsidianresearch.com> <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil> <20100309194201.GA869@suse.de> <1268163988.29493.1970.camel@moss-terrapins.epoch.ncsc.mil> <20100309195303.GH29129@obsidianresearch.com> <20100309200319.GA13609@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309200319.GA13609@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:03:19PM -0800, Greg KH wrote:
> > Yes, that is correct, I was only looking up to 2.6.33-rc8, I didn't
> > think to check Linus's head branch, my mistake. It looks to me like
> > the changeset you pointed to was put in Linus's tree after that tag,
> > so it is fixed, just not in any tagged kernel.
> 
> 2.6.33 is tagged, as is 2.6.34-rc1, so it should be showing up on your
> end by now :)

s/tagged kernel/tagged kernel in my git pull/

Network troubles today :|

git.kernel.org[0: 149.20.20.136]: errno=Connection timed out

Thanks,
Jason
