Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXEWVfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXEWVfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXEWVfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:35:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37356 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbXEWVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:35:33 -0400
Message-ID: <4654B397.8090802@pobox.com>
Date: Wed, 23 May 2007 17:35:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
References: <4635510D.4060103@shaw.ca>	<200705231349.56976.jbarnes@virtuousgeek.org>	<alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>	<200705231403.24439.jbarnes@virtuousgeek.org>	<4654AD91.1030808@pobox.com> <20070523223513.7dbb89f4@the-village.bc.nu>
In-Reply-To: <20070523223513.7dbb89f4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> One of the reasons why hardware vendors want to move away from 
>> traditional accesses is to be able to use the larger config space in 
>> PCI-Express, rather than being locked into the 256-byte legacy PCI 
>> config space.
> 
> Mostly for treacherous computing extensions where subsets of the config
> space can only be accessed by signed machines blessed by your favourite
> movie company and video card vendor...

Um, no, Mr. Paranoia, it's a standard part of the spec.

	Jeff



