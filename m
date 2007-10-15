Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXJODFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXJODFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXJODFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:05:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35557 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755436AbXJODFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:05:03 -0400
Date: Sun, 14 Oct 2007 20:04:59 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, vatsa@linux.vnet.ibm.com, dmitry.adamushko@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: git-sched patch won't boot on SN arch, 2.6.23-mm1
Message-Id: <20071014200459.1587acca.pj@sgi.com>
In-Reply-To: <20071013225735.58c6415c.pj@sgi.com>
References: <20071013225735.58c6415c.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update to list - Ingo sent me offlist a broken out patch set of this
sched work, and I'm working with him to isolate the change that is
causing this problem.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
