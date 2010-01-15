Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0AOJIM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281Ab0AOJIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:08:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0AOJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:08:09 -0500
Subject: Re: [RFC] [PATCH 3/7] Execution out of line (XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263508997.4875.32.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
	 <1263467318.4244.289.camel@laptop>
	 <1263508997.4875.32.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 10:07:35 +0100
Message-ID: <1263546455.4244.348.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 14:43 -0800, Jim Keniston wrote:
> 
> Yeah, there's not a lot of context there.  I hope it will make more
> sense if you read section 1.1 of Documentation/uprobes.txt (patch #6).
> Or look at get_insn_slot() in kprobes, and understand that we're trying
> to do something similar in uprobes, where the instruction copies have to
> reside in the user address space of the probed process.

That's not the point, changelogs shoulnd not be this cryptic. They
should be stand alone and descriptive of what, why and how.

If you can't be bothered writing such for something you want reviewed
for inclusion then I might not be bothered looking at them at all.

