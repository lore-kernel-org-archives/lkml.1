Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYE3Bxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYE3Bxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYE3Bxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:53:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38729 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532AbYE3Bxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:53:46 -0400
Date: Thu, 29 May 2008 20:53:44 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529205344.4ba1efdb.pj@sgi.com>
In-Reply-To: <483F5DAA.5060004@cn.fujitsu.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao wrote:
> I think that it is unnecessary to change cpuset_cpus_allowed_locked()'s comment
> because it isn't a static function, it is a extern function

Yes, you are correct.  My mistake.  Sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
