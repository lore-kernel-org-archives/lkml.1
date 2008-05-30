Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYE3QH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYE3QH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYE3QHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:07:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752060AbYE3QHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:07:19 -0400
Date: Fri, 30 May 2008 11:07:16 -0500
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080530110716.48ae6eb9.pj@sgi.com>
In-Reply-To: <20080530083920.cc7a029f.rdunlap@xenotime.net>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
	<20080529225708.74f65654.pj@sgi.com>
	<20080529212746.2d9cae24.rdunlap@xenotime.net>
	<20080530012537.87454a8d.pj@sgi.com>
	<20080530083920.cc7a029f.rdunlap@xenotime.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy wrote:
> Well, that's some reason for your decision.

yeah ... ;).

> I agree with Alan, of course.

So be it ... more kernel-doc comments are good,
static or not.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
