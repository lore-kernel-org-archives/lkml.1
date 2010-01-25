Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008Ab0AYWeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0AYWeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344Ab0AYWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:34:44 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:58145 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AYWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:34:43 -0500
Date: Mon, 25 Jan 2010 15:58:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, linux-mm@kvack.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/8] percpu: add __percpu sparse annotations to core
 kernel subsystems
In-Reply-To: <1264432935-10453-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1001251557570.5960@router.home>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-2-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


