Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYBUW6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYBUW6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBUW6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:58:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYBUW6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:58:19 -0500
Message-ID: <47BE01E7.7020508@garzik.org>
Date: Thu, 21 Feb 2008 17:57:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <20080221223303.GD1846@martell.zuzino.mipt.ru> <20080221224315.GA27640@kroah.com>
In-Reply-To: <20080221224315.GA27640@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Feb 22, 2008 at 01:33:03AM +0300, Alexey Dobriyan wrote:
>> Speaking of driver, could authors please comment all those barrier()
>> calls and remove trailing "return;" at the end of void functions.
> 
> Why don't you make a patch to checkpatch.pl for those types of things?
> :)

Drat, you beat me to that response.....  :)

