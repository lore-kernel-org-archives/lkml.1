Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXFDUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXFDUhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXFDUhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:37:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45090 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbXFDUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:37:31 -0400
Date: Mon, 4 Jun 2007 13:37:29 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070604133729.9b4e8886.pj@sgi.com>
In-Reply-To: <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Maybe we could make it a per-cpuset option whether children should
> inherit mems/cpus or not?

I suppose, if those needing inherited mems/cpus need it bad enough.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
