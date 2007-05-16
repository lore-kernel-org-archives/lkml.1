Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbXEPTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbXEPTNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbXEPTNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:13:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59633 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbXEPTNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:13:07 -0400
Message-ID: <464B57B7.7090404@garzik.org>
Date: Wed, 16 May 2007 15:12:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
References: <20070516144205.GV26766@think.oraclecorp.com> <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 16 2007 10:42, Chris Mason wrote:
>> For example, I'll pick on xfs for a minute.  compilebench shows the
>> default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
>> kernel trees.
> 
> I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]

Shouldn't that option be renamed to 'corrupt_my_data'?  ;-)

	Jeff



