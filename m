Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYFDC7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYFDC7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYFDC7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:59:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40920 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752181AbYFDC7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:59:20 -0400
Date: Tue, 3 Jun 2008 21:59:17 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miaox@cn.fujitsu.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080603215917.7fd5af63.pj@sgi.com>
In-Reply-To: <20080603191108.1c35d3c5.akpm@linux-foundation.org>
References: <4843AFC9.7000100@cn.fujitsu.com>
	<20080603150346.4611b5ab.akpm@linux-foundation.org>
	<4845E80F.5000808@cn.fujitsu.com>
	<4845F742.2070301@cn.fujitsu.com>
	<20080603191108.1c35d3c5.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> I already did that, didn't I?

Where can I find your attempted merge, Andrew?

Probably someplace I should know about ... sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
