Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZCFAKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZCFAKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZCFAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:09:58 -0500
Received: from fifo99.com ([67.223.236.141]:54479 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZCFAJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:09:57 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <49B0674B.2000604@oracle.com>
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
	 <1236296921.5937.109.camel@desktop>  <49B0674B.2000604@oracle.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 16:09:55 -0800
Message-Id: <1236298195.5937.112.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:59 -0800, Randy Dunlap wrote:

> > - a.) Host/target system needs to have USB debug port capability.
> > + a.) You will need two USB ports. One on the client/console system and one on 
> > +     the target system.
> > + 
> > + b.) The client/console and target USB ports must have the debug port
> > +     capability.
> 
> Is that correct on the (ugh, I think that the naming/terminology is
> still mucked up, but you didn't do that) host/target system?
> 
> On the client/console (which I would call the host and I would call the
> "Host/target" here just the Target system), a USB debug port is needed,
> but on the Host/target, it should just look like a USB device.
> At least that was the intent AFAIK/IIRC.  No?
> 

>From the rest of document I assumed Host/target was referring to both
sides of the connection. So you would need USB on both sides for this
thing to work. I assumed Client/console was just the host. I guess that
is all kind of confusing tho ..

Daniel

