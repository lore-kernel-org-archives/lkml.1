Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZEMIXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZEMIXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZEMIXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:23:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZEMIXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:23:35 -0400
Date: Wed, 13 May 2009 11:23:10 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v5 1/7] x86: instruction decorder API
Message-ID: <20090513082310.GQ18554@redhat.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004841.5505.48140.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509004841.5505.48140.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:48:42PM -0400, Masami Hiramatsu wrote:
> +++ b/arch/x86/scripts/gen-insn-attr-x86.awk
> @@ -0,0 +1,314 @@
> +#!/bin/awk -f
On some distributions (debian) it is /usr/bin/awk.

--
			Gleb.
