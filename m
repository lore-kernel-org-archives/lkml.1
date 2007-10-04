Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbXJDRcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbXJDRcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbXJDRcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:32:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40742 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759187AbXJDRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:32:18 -0400
Date: Thu, 4 Oct 2007 10:32:13 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/33] task containersv11 make cpusets a client of
 containers
Message-Id: <20071004103213.0c7ee178.pj@sgi.com>
In-Reply-To: <6599ad830710040816p63108ab1vb8547b9600b9e659@mail.gmail.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210427.888917000@menage.corp.google.com>
	<20071004025355.4a096316.pj@sgi.com>
	<6599ad830710040816p63108ab1vb8547b9600b9e659@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I didn't notice any performance hit on a pure allocate/free memory
> benchmark relative to non-cgroup cpusets.

Good.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
