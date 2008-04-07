Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYDGIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYDGIoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYDGIoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:44:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756750AbYDGIoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:44:21 -0400
Date: Mon, 7 Apr 2008 03:44:16 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
Message-Id: <20080407034416.7dfa6f18.pj@sgi.com>
In-Reply-To: <20080407081643.GC3066@elte.hu>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
	<20080407030421.0c3f8033.pj@sgi.com>
	<20080407081643.GC3066@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> the overall goal of all these patches [4096 CPU
> support in upstream Linux] is important and i'm
> enthusiastic about that ;-)

Yes, the goal is important, and yes Mike has done
a pile of excellent work meeting that goal.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
