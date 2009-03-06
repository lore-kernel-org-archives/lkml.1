Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZCFCX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZCFCX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCFCXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:23:50 -0500
Received: from fifo99.com ([67.223.236.141]:40368 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZCFCXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:23:49 -0500
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
Date: Thu, 05 Mar 2009 18:23:46 -0800
Message-Id: <1236306226.5937.120.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:59 -0800, Randy Dunlap wrote:

> Is that correct on the (ugh, I think that the naming/terminology is
> still mucked up, but you didn't do that) host/target system?
> 
> On the client/console (which I would call the host and I would call the
> "Host/target" here just the Target system), a USB debug port is needed,
> but on the Host/target, it should just look like a USB device.
> At least that was the intent AFAIK/IIRC.  No?
> 

The document indicates you need this one capability on your USB port in
addition to the USB device (check the complete document for how to find
the capability). So both host and target need this one capability, and
then you also need the USB device for the whole thing to work.

Daniel

