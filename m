Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZGATcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZGATcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZGATch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:32:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:36993 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbZGATcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:32:36 -0400
Date: Wed, 1 Jul 2009 12:31:18 -0700
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <ak@linux.intel.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
       stable@kernel.org
Subject: Re: [stable] patch kvm-add-vt-x-machine-check-support.patch added
 to 2.6.30-stable tree
Message-ID: <20090701193118.GA14703@suse.de>
References: <87d48kiliq.fsf@basil.nowhere.org>
 <4A4B67A2.9090300@redhat.com>
 <20090701141845.GW6760@one.firstfloor.org>
 <4A4B76F3.6070604@redhat.com>
 <20090701145836.GA8480@suse.de>
 <4A4B7AF4.4070205@redhat.com>
 <20090701172717.GC15542@kroah.com>
 <4A4BA881.8020908@redhat.com>
 <20090701184231.GB14128@suse.de>
 <4A4BB143.9080605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4BB143.9080605@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:56:03PM +0300, Avi Kivity wrote:
> On 07/01/2009 09:42 PM, Greg KH wrote:
> >> Where will it appear?  stable-queue wasn't what I thought it was.
> >>      
> >
> > It is now at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.1-rc2.gz
> >
> >    
> 
> What, no git?...

Sure, it's a git tree full of quilt patches:
	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=summary
apply the queue-2.6.30 patches to a clean 2.6.30 tree and you will
generate the tree.

Hope this helps,

greg k-h
