Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZDNQkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZDNQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbZDNQkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:40:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42366 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZDNQkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:40:13 -0400
Date: Tue, 14 Apr 2009 12:39:51 -0400 (EDT)
From: Jiri Pirko <jpirko@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com, mingo@elte.hu
Message-ID: <539490919.126011239727191996.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20090414155327.GG6753@linux.vnet.ibm.com>
Subject: Re: [PATCH] rculist.h: introduce list_entry_rcu and
 list_first_entry_rcu
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> There are a couple more places where this primitive could be applied.
> I would welcome a patch for these as well.
> 
Ok I will do this once this patch hits the tree.

Jirka
