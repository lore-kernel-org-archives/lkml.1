Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbXIGO4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbXIGO4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXIGO4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:56:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXIGO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:56:31 -0400
Message-ID: <46E1669A.2040402@redhat.com>
Date: Fri, 07 Sep 2007 10:56:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Karl Bellve <Karl.Bellve@umassmed.edu>, linux-kernel@vger.kernel.org
Subject: Re: PCI: Unable to reserve mem region problem
References: <46DEBE06.5010401@umassmed.edu> <20070906013145.1c14557e@the-village.bc.nu>
In-Reply-To: <20070906013145.1c14557e@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2007 08:31 PM, Alan Cox wrote:
> On Wed, 05 Sep 2007 10:32:38 -0400
> "Karl Bellve" <Karl.Bellve@umassmed.edu> wrote:
> 
>> Please CC any response. Thanks.
>>
>> I am having an issue with a Supermicro h8dce motherboard and failure to 
>> recognize a 5th SATA drive after upgrading to Fedora 7.
> 
> Can you send me an lspci -vvxxx so that I can look into this. Might be a
> few days with the kernel summit but it should give a clue and may be
> linked to ADMA mode

It's in RH bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=280641
