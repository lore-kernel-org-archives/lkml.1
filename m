Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbYFFOWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbYFFOWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYFFOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:22:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55507 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYFFOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:22:31 -0400
Date: Fri, 6 Jun 2008 19:52:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] kprobes: add tests for register_kprobes
Message-ID: <20080606142206.GK1798@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <484944CA.902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484944CA.902@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 10:08:10AM -0400, Masami Hiramatsu wrote:
> Add testcases for *probe batch registration (register_kprobes)
> to kprobes sanity tests.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
