Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbXJPAQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbXJPAQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXJPAQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:16:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53433 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876AbXJPAQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:16:45 -0400
Date: Mon, 15 Oct 2007 17:16:36 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: rientjes@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
Message-Id: <20071015171636.6213bf43.pj@sgi.com>
In-Reply-To: <4713DA85.3020208@google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com>
	<4713DA85.3020208@google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Here's an alternative for consideration, below.

I don't see the alternative -- I just see my patch, with the added
blurbage:

  #12 - /usr/local/google/home/menage/kernel9/linux/kernel/cpuset.c ====
  # action=edit type=text

Should I be increasing my caffeine intake?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
