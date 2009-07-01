Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZGASm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZGASm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZGASmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:42:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:35004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZGASmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:42:50 -0400
Date: Wed, 1 Jul 2009 11:42:31 -0700
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <ak@linux.intel.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
       stable@kernel.org
Subject: Re: [stable] patch kvm-add-vt-x-machine-check-support.patch added
 to 2.6.30-stable tree
Message-ID: <20090701184231.GB14128@suse.de>
References: <4A4B0BB1.2010102@linux.intel.com>
 <4A4B11A6.6080402@redhat.com>
 <87d48kiliq.fsf@basil.nowhere.org>
 <4A4B67A2.9090300@redhat.com>
 <20090701141845.GW6760@one.firstfloor.org>
 <4A4B76F3.6070604@redhat.com>
 <20090701145836.GA8480@suse.de>
 <4A4B7AF4.4070205@redhat.com>
 <20090701172717.GC15542@kroah.com>
 <4A4BA881.8020908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4BA881.8020908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:18:41PM +0300, Avi Kivity wrote:
> On 07/01/2009 08:27 PM, Greg KH wrote:
> > Thanks, I've now done this, and will push out a 2.6.30.1-rc2 in a bit so
> > you can test with that as well.
> >    
> 
> Where will it appear?  stable-queue wasn't what I thought it was.

It is now at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.1-rc2.gz

thanks,

greg k-h
