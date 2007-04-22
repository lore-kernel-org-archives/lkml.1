Return-Path: <linux-kernel-owner+w=401wt.eu-S1030848AbXDVNMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848AbXDVNMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030857AbXDVNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:12:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:14234 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030852AbXDVNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type:from;
        b=K7IjKkEpoOt8pjRXqWnWMsvoaIU7TSPxvObApHJJj0sfTLRgrPNbe/GYGtf5noaYNWELE26mra03c8xtcTQMMdXYgHbQF1gE63EOyBtbxGJlQWtw6UuATbItZyRln2hyvse5kXOB6dADmTTbO3s7iDHi1iBG/BTXP1+cAYGvZ7A=
Date: Sun, 22 Apr 2007 14:20:26 +0100 (BST)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: InitIO SCSI: Volunteers required
In-Reply-To: <20070420103849.7358f1f1@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0704221416440.5217@thor.lan>
References: <20070420103849.7358f1f1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Srdjan Todorovic <todorovic.s@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Alan Cox wrote:

> I'm looking for some testers for a revamp of the initio driver. No real
> code changes other than to hopefully stop it exploding on load on 64bit,
> but a major reorganisation, commenting and "de-windowsification" so the
> code is actually readable and I can do the pci_find_device to
> pci_get_device transitions.
> 
> Alan

I have such a card in my box right now, and would definitely be happy to
test any changes.

I also have a couple of patches for the driver, but need to regenerate
the diffs and test them. Hopefully I can do that sometime this coming
week, and I'll be sure to CC you when I post them to linux-scsi ML.

Thanks

Srdjan Todorovic
