Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZCDVdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZCDVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZCDVdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:33:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:42772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbZCDVdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:33:40 -0500
Date: Wed, 4 Mar 2009 13:25:03 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Yinghai Lu <yinghai@kernel.org>, Sarah Sharp <sarah.a.sharp@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: EHCI debug documentation
Message-ID: <20090304212503.GA9611@suse.de>
References: <20090303235354.GA7145@gamba.jf.intel.com> <86802c440903031731x36c1180dk72a3631bb4397319@mail.gmail.com> <49ADDB0B.1050002@oracle.com> <20090304175727.GC29823@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304175727.GC29823@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Yinghai Lu wrote:
> > b. netchip USB debug cable
> 
> http://www.plxtech.com/products/NET2000/NET20DC/default.asp

I have reports that the newer version of this device does not work on
Linux as it isn't enumeratable as a "real" usb device on one end.

I don't have one of these new devices yet to test it out, has anyone
else heard of this problem?

thanks,

greg k-h
