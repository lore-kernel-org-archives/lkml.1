Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXK1Umo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXK1Umo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbXK1Umg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:42:36 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:65492 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbXK1Ume (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:42:34 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvmj4KLNZA==
Message-ID: <474DD274.5060909@tragetaschen.dyndns.org>
Date: Wed, 28 Nov 2007 21:41:24 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Bogus PCI vendor ID
References: <473F0FE0.3010501@tragetaschen.dyndns.org> <20071117184030.GA5541@electric-eye.fr.zoreil.com> <53552.simon.1195474940@5ec7c279.invalid> <20071119092736.7cb21231@freepuppy.rosehill> <20071124202815.fed44890.akpm@linux-foundation.org> <47496C43.4090109@tragetaschen.dyndns.org> <20071126165353.GA24825@fattire.cabal.ca>
In-Reply-To: <20071126165353.GA24825@fattire.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Sun, Nov 25, 2007 at 01:36:19PM +0100, Kai Ruhnau wrote:
>   
>> If this is the same like the kernel option 'pci=conf1', that fixes the
>> vendor IDs.
>>     
>
> Same effect. Ubuntu and many other distros are shipping kernels with
> MMCONFIG off by default for reasons like this. Check to see if you have
> an updated BIOS from your motherboard manufacturer?
>   

No, nothing available there. (OEM board, running fine under Vista, I
don't expect to get support there...)

Kai

-- 
This signature is left as an exercise for the reader.

