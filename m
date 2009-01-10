Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZAJWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZAJWZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZAJWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:25:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47329 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZAJWZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:25:33 -0500
Message-ID: <4969204A.3090606@redhat.com>
Date: Sat, 10 Jan 2009 17:25:14 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>	 <20090107123457.GB16268@elte.hu>	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>	 <1231598714.11642.53.camel@quest>  <20090110155720.GA10954@redhat.com> <1231607252.11642.103.camel@quest>
In-Reply-To: <1231607252.11642.103.camel@quest>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> That's pretty neat, much nicer than what we had before.  So what about
> waitfd() [I think I've slightly changed Casey's API here, or he changed
> my proposed one <g>]?
>   
I think you might have changed the argument order slighly, but other 
than that, counting the corrections I've made from feedback here, its 
about the same.

--CJD
