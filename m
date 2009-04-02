Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZDBAsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZDBAsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZDBAsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:48:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZDBAsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:48:42 -0400
Date: Wed, 1 Apr 2009 17:48:16 -0700
From: Chris Wright <chrisw@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090402004816.GD1117@x200.localdomain>
References: <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <49D3F088.50600@redhat.com> <49D4076D.4010500@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4076D.4010500@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> You can't change ABIs after something is merged or you break userspace.   
> So you need to figure out the right ABI first.

Absolutely.
