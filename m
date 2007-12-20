Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbXLTRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbXLTRAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbXLTRAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:00:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbXLTRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:00:43 -0500
Message-ID: <476A9FB5.90001@redhat.com>
Date: Thu, 20 Dec 2007 12:00:37 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce	PCI_USING_MMCONF]
References: <476A5EAF.6020008@redhat.com> <476A79D4.4090002@redhat.com> <20071220164819.GA15496@kroah.com>
In-Reply-To: <20071220164819.GA15496@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Sure, but you do not reference it in this patch, right?  So it's not
> needed until you actually use it, so just include it in the patch that
> you are needing it in.
> 
> thanks,
> 
> greg k-h

Will do.
