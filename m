Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbYFDEH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbYFDEH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbYFDEHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:07:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59402 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbYFDEHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:07:20 -0400
Date: Tue, 3 Jun 2008 23:07:16 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miaox@cn.fujitsu.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080603230716.56634b9c.pj@sgi.com>
In-Reply-To: <20080603210221.0978307c.akpm@linux-foundation.org>
References: <4843AFC9.7000100@cn.fujitsu.com>
	<20080603150346.4611b5ab.akpm@linux-foundation.org>
	<4845E80F.5000808@cn.fujitsu.com>
	<4845F742.2070301@cn.fujitsu.com>
	<20080603191108.1c35d3c5.akpm@linux-foundation.org>
	<20080603215917.7fd5af63.pj@sgi.com>
	<20080603210038.51aabd12.akpm@linux-foundation.org>
	<20080603210221.0978307c.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, replying to Andrew:
> > Sigh, sorry.  I need to drop and redo them anyway.
> 
> hey, who are you calling senile?  You were cc'ed.

 ... once again demonstrating that Aussies a sense of humor
beyond the grasp of the rest of us mere mortals.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
