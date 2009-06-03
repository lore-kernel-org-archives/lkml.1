Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZFCEwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZFCEwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZFCEv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:51:56 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:55944 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZFCEvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:51:55 -0400
MIME-Version: 1.0
Message-ID: <3ab07e3b-a601-48d5-b350-29cbaf111892@default>
Date: Tue, 2 Jun 2009 21:49:58 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>, Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: RE: Merge Xen (the hypervisor) into Linux
In-Reply-To: <alpine.DEB.2.00.0906022332230.14994@gandalf.stny.rr.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A2600FF.0081:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, Jun 02, 2009 at 05:00:21PM -0700, Dan Magenheimer wrote:
> > > That sound you heard was 10000 xen-users@lists.xensource.com
> > > all having heart attacks at once.
> > > 
> > > Need I say more.
> > 
> > So maybe I'm stupid, but why would they be having heart attacks?
> 
> Maybe because they asked for an apple and got an apple pie?
> 
> That is, they are pushing hard for an interface for Dom0, and 
> Ingo just 
> agreed to take it along with the entire Xen hypervisor ;-)

Um, no, he did not.  He and Avi suggested that Xen be completely
rearchitected to suit Linux's preferences. 

A hypervisor is not an operating system.  Yes there is
similarity in a number of pieces of code.  But there's
some similarity between Java and Linux too...

> Perhaps the rightful place for the Xen hypervisor is in 
> Linux. Xen 
> is GPL right? Thus we could do this even with out the permission from 
> Citrix.

(tongue firmly in cheek in case you might assume otherwise)
Linux is GPL right?  Perhaps the rightful place for the Linux
operating system is part of Java.  Thus we could do this even
with out the permission from Ingo.

> I just don't see 
> the Xen team cooperating with the Linux team.  But maybe those 
> are the old days. 

Yes, let's fix that.  Let's start turning this discussion towards
how we can cooperate better.

> The Dom0 push of Xen just seems too much like Linux being Xen's sex 
> slave, when it should be the other way around.

I can certainly see how it might feel that way, but it needn't
be... nor the other way around.  But in the end, only the end users
matter.  If we can't cooperate, we simply cede the war to Windows
and Hyper-V.
