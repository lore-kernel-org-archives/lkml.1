Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbZFGNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbZFGNDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZFGNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:02:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:47008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbZFGNCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:02:09 -0400
Subject: Re: Xen is a feature
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
In-Reply-To: <4A2BB6B1.4040805@redhat.com>
References: <4A1F302E.8030501@goop.org>
	 <20090528.210559.137121893.davem@davemloft.net>
	 <4A1FCE8E.2060604@eu.citrix.com>
	 <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
	 <4A25564A.70608@eu.citrix.com>
	 <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
	 <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain>
	 <4A257687.2030801@redhat.com> <20090607091349.GA26897@elte.hu>
	 <4A2B9001.7090706@redhat.com> <20090607103547.GR31286@elte.hu>
	 <4A2BB6B1.4040805@redhat.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 18:32:40 +0530
Message-Id: <1244379760.30664.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 15:46 +0300, Avi Kivity wrote:
> Ingo Molnar wrote:
> >
> > The 'slim hypervisor' model i was suggesting was a slimmed down 
> > _Linux_ kernel.
> >   
> 
> Yeah, I lost the context.  I should reduce my own context switching.
> 

It would be better if we monitor the switching, entry/exit and other
useful parameters in count and frequency using debugfs to increase the
performance.

Thanks,
--
JSR

