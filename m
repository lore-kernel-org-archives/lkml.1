Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYJAJE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYJAJE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYJAJB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:01:59 -0400
Received: from styx.suse.cz ([82.119.242.94]:43885 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977AbYJAJB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:01:57 -0400
Date: Wed, 1 Oct 2008 11:01:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Randy Dunlap <rdunlap@xenotime.net>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
In-Reply-To: <20081001085509.GG18732@tekkaman>
Message-ID: <alpine.LNX.1.10.0810011100120.4022@jikos.suse.cz>
References: <20080930153708.GX18732@tekkaman> <Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz> <20080930230644.107e6428.kristoffer.ericson@gmail.com> <alpine.LNX.1.10.0809302340190.4022@jikos.suse.cz> <20080930154908.aaf80a11.rdunlap@xenotime.net>
 <20081001085509.GG18732@tekkaman>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, Rodolfo Giometti wrote:

> > Ack.  And there is no MISC maintainer, so Jiri's patch to remove the 
> > entire entry makes sense IMO.
> However misc devices exist, so no maintaner for them? I'd like to
> propose a misc device and I'd like to have some suggestions about it,
> so should I send my questions to the LKML?

If you have a driver that doesn't fit under any particular subsystem, it 
therefore probably belongs into drivers/misc, yes.

Send them to LKML and CC Andrew Morton and possibly also Greg KH.

Thanks,

-- 
Jiri Kosina
SUSE Labs
