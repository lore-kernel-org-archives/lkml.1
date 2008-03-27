Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYC0JWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYC0JWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYC0JVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:21:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52668 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbYC0JVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:21:51 -0400
Date: Thu, 27 Mar 2008 04:21:47 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
 setup_data to boot protocol
Message-Id: <20080327042147.15f7ce28.pj@sgi.com>
In-Reply-To: <20080327090925.GC30918@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com>
	<20080327083221.GD15626@elte.hu>
	<20080327040216.99dcde7b.pj@sgi.com>
	<20080327090925.GC30918@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> stupidly shortsighted limit ...

Eh ... I don't think all that shortsighted ... that 4096 limit has
probably been around longer than Linux.  Linus or hpa or others would
know the history better than I do.

> in case anyone knows about any other ... please tell us 

We're pushing into and finding those limits as best we can, here at
SGI ;).  You've heard of the canary in the mine shaft, and the elephant
in the room.  Well, we're the elephant in the canary cage.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
