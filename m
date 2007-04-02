Return-Path: <linux-kernel-owner+w=401wt.eu-S965984AbXDBV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984AbXDBV4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965983AbXDBV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:56:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48024 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965981AbXDBV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:56:17 -0400
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
	 <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>
	 <200704011246.52238.ak@suse.de>
	 <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>
	 <1175544797.22373.62.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021324480.31842@schroedinger.engr.sgi.com>
	 <1175548086.22373.99.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:56:08 -0700
Message-Id: <1175550968.22373.122.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 14:28 -0700, Christoph Lameter wrote:
> I do not care what its called as long as it 
> covers all the bases and is not a glaring performance regresssion (like 
> SPARSEMEM so far). 

I honestly don't doubt that there are regressions, somewhere.  Could you
elaborate, and perhaps actually show us some numbers on this?  Perhaps
instead of adding a completely new model, we can adapt the existing ones
somehow.

But, without some cold, hard, data, we mere mortals without the 1024-way
machines can only guess. ;)

-- Dave

