Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXJCU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXJCU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXJCU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:56:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50744 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbXJCU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:56:20 -0400
Date: Wed, 3 Oct 2007 13:56:15 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, menage@google.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org,
       containers@lists.osdl.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for
 cpusets
Message-Id: <20071003135615.f2e42b8b.pj@sgi.com>
In-Reply-To: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew - please kill this patch.

Looks like Paul Menage has a better solution
that I will be trying out.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
