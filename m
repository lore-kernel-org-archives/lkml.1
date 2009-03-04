Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbZCDTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbZCDTxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZCDTxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:53:22 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:42519 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbZCDTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:53:21 -0500
Date: Wed, 4 Mar 2009 13:53:14 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Dan Smith <danms@us.ibm.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
Message-ID: <20090304135314.618ad07e@thinkcentre.lan>
In-Reply-To: <1236128437.22399.31.camel@nimitz>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
 <1236095764-19325-3-git-send-email-danms@us.ibm.com>
 <1236097332.22399.8.camel@nimitz> <878wnmrtp9.fsf@caffeine.danplanet.com>
 <1236128437.22399.31.camel@nimitz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 1BC5491A-08F6-11DE-A84F-CBE7E3B37BAC-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 17:00:37 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Tue, 2009-03-03 at 16:57 -0800, Dan Smith wrote:
> > DH> Did you convince Nathan that this ends up being a good idea?
> > 
> > Technically he hasn't seen this version, but my hopes are not high
> > that he will change his mind.  If the feedback is that they're not
> > liked, I'll happily remove them.
> 
> I just figure if Nathan feels that strongly that we'll encounter more
> people who feel even more so.  So, I was curious if he changed his mind
> somehow.

No, not really, sorry.

I understand why it's nice for the developer to have this sort of
helper, but I don't think it's nice for someone trying to review or
debug the code.

Surely discussing these macros has already consumed more developer time
than they would ever save?  :)
