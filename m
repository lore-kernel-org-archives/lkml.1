Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbXJKVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbXJKVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXJKVue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:50:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32859 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbXJKVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:50:33 -0400
Message-ID: <470E9AA6.4070205@garzik.org>
Date: Thu, 11 Oct 2007 17:50:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] PCI: Add 'nodomains' boot option, and	pci_domains_supported
 global
References: <20071011205727.GA29222@havoc.gtf.org> <20071011213840.GB32752@kroah.com>
In-Reply-To: <20071011213840.GB32752@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Oct 11, 2007 at 04:57:27PM -0400, Jeff Garzik wrote:
>> +enum { pci_domains_supported = 0; };
> 
> I don't think you compiled this option :)
> 
> I've fixed the compiler error in my version.

Thanks!


