Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZEDUx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZEDUx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZEDUxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:53:46 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:49178 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZEDUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:53:46 -0400
Message-ID: <49FF55D5.6060103@nortel.com>
Date: Mon, 04 May 2009 14:53:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Olivier Galibert <galibert@pobox.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org> <20090504170636.GA56325@dspnet.fr.eu.org> <20090504172731.GA32651@infradead.org>
In-Reply-To: <20090504172731.GA32651@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2009 20:53:42.0858 (UTC) FILETIME=[68C7BAA0:01C9CCFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:

> Because of that let us assume that IBM Corporate, Paul E. McKenney, Andrew
> Tridgell and other know what code exactly infridges that patent.  IBM
> has worked around that code in the various embedded Linux offerings they
> ship and probably urge distributors to disable it.  Why would we not
> remove that code unconditionally in that case and let other people
> infridge it?
> 
> Or that patent is believed to be invalid and faught, and there was
> absolute no reason to remove it except for companies doing as part of a
> settlement and they could do it in their privat trees.

What about the scenario where a patent is valid in certain parts of the 
world but not in others?  It seems possible that in this scenario there 
may be valid reasons to have a config option.

Chris
