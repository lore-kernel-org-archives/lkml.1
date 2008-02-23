Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYBWNIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYBWNIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYBWNI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:08:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52213 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbYBWNI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:08:27 -0500
Date: Sat, 23 Feb 2008 07:08:26 -0600
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: harvey.harrison@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: sparse warnings in cpuset.c
Message-Id: <20080223070826.380c779a.pj@sgi.com>
In-Reply-To: <20080223000434.7322d1c9.akpm@linux-foundation.org>
References: <1202019619.1844.52.camel@brick>
	<20080203012815.05a50b13.pj@sgi.com>
	<1202024543.1844.57.camel@brick>
	<20080223000434.7322d1c9.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm wrote:
> ^^^^^^ I suck.

Yeah, right ... and Dolly Parton is flat chested ;).

> Sorry, the above code doesn't seem to exist any more.

It moved from cpuset.c to cgroup.c.  I just sent a reincarnated patch:

  [PATCH] cgroup: fix sparse warning of shadow symbol in cgroup.c

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
