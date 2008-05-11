Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYEKN6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYEKN6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYEKN57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:57:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37689 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbYEKN56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:57:58 -0400
Date: Sun, 11 May 2008 08:57:57 -0500
From: Paul Jackson <pj@sgi.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm, travis@sgi.com
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
Message-Id: <20080511085757.b68c1a48.pj@sgi.com>
In-Reply-To: <20080511135039.GA3286@mailshack.com>
References: <20080511135039.GA3286@mailshack.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander wrote:
> Each use of the for_each_cpu_mask
> constuct then becomes a few bytes smaller. 

Looks good, at first glance.

Could you include Mike Travis <travis@sgi.com> on
the CC list for this work?  He's been having
fun lately with cpumasks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
