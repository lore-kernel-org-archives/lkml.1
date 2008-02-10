Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYBJDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYBJDWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbYBJDWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:22:03 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41943 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755560AbYBJDWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:22:02 -0500
Date: Sat, 9 Feb 2008 21:21:56 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       gregkh@suse.de, rusty@rustcorp.com.au
Subject: Re: [git pull] CPU isolation extensions (updated)
Message-Id: <20080209212156.ecc72fee.pj@sgi.com>
In-Reply-To: <47AE6A8B.6030908@qualcomm.com>
References: <47AE6A8B.6030908@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Linus, please pull CPU isolation extensions from

Did I miss something in this discussion?  I thought
Ingo was quite clear, and Linus pretty clear too,
that this patch should bake in *-mm or some such
place for a bit first.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
