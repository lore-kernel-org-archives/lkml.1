Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYILSps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYILSps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYILSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:45:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63989 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYILSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:45:39 -0400
Date: Fri, 12 Sep 2008 11:44:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Diggs <kevdig@hypersurf.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Add kernel doc for the completion, fix
 kernel-doc-nano-HOWTO.txt
Message-Id: <20080912114441.ce25096f.randy.dunlap@oracle.com>
In-Reply-To: <20080826083202.GA24733@elte.hu>
References: <48B29696.3070808@hypersurf.com>
	<20080826083202.GA24733@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 10:32:02 +0200 Ingo Molnar wrote:

> 
> * Kevin Diggs <kevdig@hypersurf.com> wrote:
> 
> > This patch adds kernel doc for the completion feature. It is in 
> > kernel/sched.c and include/linux/completion.h.
> >
> > An error in the split-man.pl PERL snippet in kernel-doc-nano-HOWTO.txt 
> > is also fixed.
> 
> applied to tip/sched/devel - thanks Kevin!

Ack and thanks, but next time, please describe the error that is being
fixed.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
