Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZCEXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZCEXM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZCEXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:12:16 -0500
Received: from fifo99.com ([67.223.236.141]:48047 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZCEXMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:12:15 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <49B05ACF.2010708@oracle.com>
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
	 <1236294142.5937.88.camel@desktop>  <49B05ACF.2010708@oracle.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 15:12:13 -0800
Message-Id: <1236294733.5937.92.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:05 -0800, Randy Dunlap wrote:
> Daniel Walker wrote:
> > On Thu, 2009-03-05 at 17:54 -0500, Alan Stern wrote:
> >> On Thu, 5 Mar 2009, Daniel Walker wrote:
> >>
> >>> Fix up some typos, and make the requirements section slightly cleaner.
> >>>
> >>> Signed-Off-By: Daniel Walker dwalker@fifo99.com
> >>>
> >>> diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
> >>> index 607b1a0..5b51aef 100644
> >>> --- a/Documentation/x86/earlyprintk.txt
> >>> +++ b/Documentation/x86/earlyprintk.txt
> >>> @@ -9,7 +9,9 @@ and two USB cables, connected like this:
> >>>  
> >>>  1. There are three specific hardware requirements:
> >>>  
> >>> - a.) Host/target system needs to have USB debug port capability.
> >>> + a.) You will need two USB ports. One on the client/console system and one one the target system.
> >> s/one one/one on/
> > 
> > Check.
> > 
> >> You might also try harder to observe the 80-column rule.
> > 
> > I wasn't aware it applied to documents ..
> 
> Yes, it does.
> 

Shall we add that to a document style guide? There's several other docs
that don't conform to that..

Daniel

