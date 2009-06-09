Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZFIWPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZFIWPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZFIWPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:15:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZFIWPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:15:41 -0400
Date: Tue, 9 Jun 2009 15:15:20 -0700
From: Valerie Aurora <vaurora@redhat.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090609221517.GA3608@fsbox>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1244115530.4120.30.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244115530.4120.30.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:38:50PM +0100, Scott James Remnant wrote:
> On Mon, 2009-05-18 at 18:08 +0200, Jan Blunck wrote:
> 
> > Here is another post of the VFS based union mount implementation.
> > 
> Awesome work, this may just get us out of a tight spot with our LiveCD.
> A switch to a devmapper/snapshot based implementation lost the property
> that we could rsync the filesystem (squashfs has been nicely rsyncable).
> 
> What kind of testing do you need doing, and where would you like the bug
> reports/patches? :-)

Just try to use it to do real work and I'm sure it will break real
good. :) Bug reports and patches to linux-fsdevel@vger.kernel.org and
cc'd to Jan and I.

Thanks!

-VAL
