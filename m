Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZHZVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZHZVeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZHZVeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:34:18 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51026 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZHZVeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oRCoo8QFQD6fZ+fhXic/F6O6gTrAput4qbnQxirG8hvH/VRNXviCH11EZCImIV4RzL
         HTAFb/yUT/tiMgdbOZvYdjXtnZhmfjlmMiYevJi8D03ipDSGppal3D4wvErES6hURPIM
         o6iikAKq7nWss+8oBK/5dv2uq6/p1k29dZgdA=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, cfriesen@nortel.com,
       efault@gmx.de, riel@redhat.com, wiseman@macs.biu.ac.il,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090826135041.e6169d18.akpm@linux-foundation.org>
References: <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	 <20090826193252.GA14721@elte.hu>
	 <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
	 <20090826135041.e6169d18.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 00:34:13 +0300
Message-Id: <1251322453.3882.44.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-08-26 at 13:50 -0700, Andrew Morton wrote:
> On Wed, 26 Aug 2009 16:40:09 -0400 (EDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > Peter has not given a solution to the problem. Nor have you.
> 
> What problem?
> 
> All I've seen is "I want 100% access to a CPU".  That's not a problem
> statement - it's an implementation.
> 
> What is the problem statement?
> 
> 
> My take on these patches: the kernel gives userspace unmediated access
> to memory resources if it wants that.  The kernel gives userspace
> unmediated access to IO devices if it wants that.  But for some reason
> people freak out at the thought of providing unmediated access to CPU
> resources.
> 
> Don't get all religious about this.  If the change is clean,
> maintainable and useful then there's no reason to not merge it.
thank you Mr Morton. thank you !!!


