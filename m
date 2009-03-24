Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZCXGkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZCXGkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZCXGkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:40:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40102 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZCXGkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:40:00 -0400
Date: Tue, 24 Mar 2009 12:09:54 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, bharata@linux.vnet.ibm.com
Subject: Re: [BUGFIX][PATCH -tip] x86: kretprobe-booster interrupt
	emulation code fix
Message-ID: <20090324063954.GA4552@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49C7995C.2010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C7995C.2010601@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:14:52AM -0400, Masami Hiramatsu wrote:
> Fix interrupt emulation code in kretprobe-booster according to
> pt_regs update (es/ds change and gs adding).
> 
> This issue has been reported on systemtap-bugzilla:
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=9965
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Tested on -tip. Thanks Masami.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Ananth
