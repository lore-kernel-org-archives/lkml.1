Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXJXDc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXJXDc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXJXDcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:32:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45940 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXJXDcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:32:17 -0400
Date: Wed, 24 Oct 2007 09:01:47 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Use struct path in struct nameidata
Message-ID: <20071024033147.GA6355@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com> <20071022135758.GA17051@lst.de> <20071023023355.GA7829@in.ibm.com> <20071023084305.GJ17591@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023084305.GJ17591@hasse.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:43:05AM +0200, Jan Blunck wrote:
> 
> The thing is: how do we keep going from here? Do you want to send my patches
> in the future or are you going to ask me before sending things out? We don't
> need to duplicate the work here. I already put my quilt stack into a public
> place for you to work on them but I don't like the way this is going on at the
> moment.

My intention was to help speed up the Union Mount effort by ensuring
that patches don't rot waiting for developer's attention. Going by the
past interactions, I got a feeling that you have lot of other work
besides this, while I have time to spare on this. Hence wanted to do my
bit to get patches moving as quickly as possible.

As I have conveyed to you many times, I would still like you to maintain
the patches and send out as timely as possible on lkml. If you can't do
this because of your other commitments, then I would more than willing
to maintain these and give them maximum attention.

And thanks for making available the patches publicly, I have been asking
this for months now.

Regards,
Bharata.
