Return-Path: <linux-kernel-owner+w=401wt.eu-S934622AbZDBF7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622AbZDBF7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZDBF7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:59:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57998 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZDBF7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:59:22 -0400
Date: Wed, 1 Apr 2009 22:59:06 -0700
From: Chris Wright <chrisw@redhat.com>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Chris Wright <chrisw@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com,
       hugh@veritas.com, corbet@lwn.net, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4 alternative userspace] add ksm kernel shared memory
	driver
Message-ID: <20090402055906.GH1117@x200.localdomain>
References: <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402054816.GG1117@x200.localdomain> <36ca99e90904012257j5f5e6e2co673ff2433d49b7b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90904012257j5f5e6e2co673ff2433d49b7b9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bert Wesarg (bert.wesarg@googlemail.com) wrote:
> > Unregister a shareable memory region (not currently implemented):
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> > madvise(void *addr, size_t len, MADV_UNSHAREABLE)
> I can't find a definition for MADV_UNSHAREABLE!

It's not there ;-)
