Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbYAWRjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbYAWRjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYAWRil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:38:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48331 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756250AbYAWRij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:38:39 -0500
Date: Wed, 23 Jan 2008 11:38:42 -0600
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com,
       ak@suse.de, adaplas@pol.net, linux-kernel@vger.kernel.org
Subject: Re: Could you please merge the x86_64 EFI boot support patchset?
Message-Id: <20080123113842.a6177cb5.pj@sgi.com>
In-Reply-To: <1201075675.4945.44.camel@caritas-dev.intel.com>
References: <1194831950.17223.44.camel@caritas-dev.intel.com>
	<20080123010051.969d21fd.pj@sgi.com>
	<1201073166.4945.41.camel@caritas-dev.intel.com>
	<20080123014653.6261020c.pj@sgi.com>
	<1201075675.4945.44.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Huang wrote:
> > Are you optimistic that some variation of H. Peter Anvin's "struct
> > setup_data" mechanism will make it into 2.6.25 or thereabouts?
> 
> I think it may be merged into 2.6.26.

That (2.6.26) is just barely within the schedule SGI needs.
I hope the chances of making it by then are good.  I'm no
expert in this area, but I'll do what little I can to help
review and test.

Good luck ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
