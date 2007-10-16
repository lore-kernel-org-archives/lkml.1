Return-Path: <linux-kernel-owner+w=401wt.eu-S965720AbXJPXPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965720AbXJPXPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbXJPXOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:14:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60312 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755601AbXJPXOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:14:53 -0400
Date: Tue, 16 Oct 2007 16:14:45 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
Message-Id: <20071016161445.2f866d42.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710161121450.32268@chino.kir.corp.google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com>
	<alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
	<20071015230729.53fcbaf7.pj@sgi.com>
	<alpine.DEB.0.9999.0710152311180.22383@chino.kir.corp.google.com>
	<20071016021626.15b94649.pj@sgi.com>
	<alpine.DEB.0.9999.0710161121450.32268@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Not necessarily because migration only occurs to any online cpu in the 
> mask, it won't attempt to migrate it to some cpu that has been downed.
> ...

... one of David or I is insane ... I can't tell which one yet,
perhaps both of us ;).

I'm going to reply to David without all the CC list above.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
