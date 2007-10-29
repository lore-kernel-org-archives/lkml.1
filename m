Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXJ2XUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXJ2XUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJ2XUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:20:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756103AbXJ2XUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:20:04 -0400
Date: Mon, 29 Oct 2007 16:20:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: Re: [RFC] Create instrumentation directory (git repository)
In-Reply-To: <20071029215138.GA4233@Krystal>
Message-ID: <Pine.LNX.4.64.0710291619210.4821@schroedinger.engr.sgi.com>
References: <20071029215138.GA4233@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Mathieu Desnoyers wrote:

> vm/vmstat.c

The vm statistics are important for the operation of the VM. They are not 
optional. So I do not think that they fall under the category of 
instrumentation.
