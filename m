Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYFPIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYFPIkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYFPIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:40:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34058 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754155AbYFPIkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:40:07 -0400
Date: Mon, 16 Jun 2008 03:40:02 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/8] x86 boot: x86_64 build reserve_bootmem_generic fix
Message-Id: <20080616034002.9f5f1a1b.pj@sgi.com>
In-Reply-To: <86802c440806152350m34f751a9qf29c98d09b7b9f7a@mail.gmail.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806152350m34f751a9qf29c98d09b7b9f7a@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> can you check latest tip/master?

Ok - I suppose you mean tip/master in the linux-next tree.

I see there a slightly different writing of this code,
that does not need this fix.  Good.

I guess this current patch of mine should be dropped then,
as it is no longer needed.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
