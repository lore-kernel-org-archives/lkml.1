Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbXFDQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbXFDQ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbXFDQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:29:28 -0400
Received: from rtr.ca ([64.26.128.89]:1392 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbXFDQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:29:27 -0400
Message-ID: <46643DE5.3080904@rtr.ca>
Date: Mon, 04 Jun 2007 12:29:25 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com> <46613C53.8010205@gmail.com> <4661E6CA.1080203@dgreaves.com>
In-Reply-To: <4661E6CA.1080203@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> I have 2 ide disks. If I enable SMART and hibernate/suspend2disk, SMART is
> disabled when I resume.

Just a thought:  This *may* be fixable at the drive, with "hdparm -K1".

Cheers 
