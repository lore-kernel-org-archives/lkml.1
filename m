Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZFATyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZFATyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZFATxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:53:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZFATxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:53:53 -0400
Date: Mon, 1 Jun 2009 15:53:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Avi Kivity <avi@redhat.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?ISO-8859-15?Q?Christian_Borntr=E4ger?= <borntraeger@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
In-Reply-To: <4A2430A4.1080908@redhat.com>
Message-ID: <alpine.DEB.2.00.0906011552570.14994@gandalf.stny.rr.com>
References: <1243581494.3212.1.camel@localhost.localdomain> <200905290948.34482.borntraeger@de.ibm.com> <1243586626.4379.15.camel@localhost.localdomain> <20090601192624.GA32428@goodmis.org> <4A2430A4.1080908@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 1 Jun 2009, Avi Kivity wrote:
> 
> localversion would show up in linux-next, not sure if that's a problem.  On
> the other hand, I'm not sure what it's worth.

If a localversion file with "-kvm" showed up in linux-next, I would 
consider that a problem.

-- Steve

