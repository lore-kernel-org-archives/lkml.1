Return-Path: <linux-kernel-owner+w=401wt.eu-S937776AbXHGW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937776AbXHGW04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935518AbXHGW0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:26:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761257AbXHGW0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:26:42 -0400
Message-ID: <46B8F19D.6060406@garzik.org>
Date: Tue, 07 Aug 2007 18:26:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kyle McMartin <kyle@mcmartin.ca>
CC: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines
References: <200708052114.01790.rjw@sisk.pl> <46B8E6D4.30405@garzik.org> <200708080024.28692.rjw@sisk.pl>
In-Reply-To: <200708080024.28692.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 7 August 2007 23:40, Jeff Garzik wrote:
>> I'll let our new tulip maintainer see what he thinks about the 
>> implementation.  Seems fairly sane to me, but should at least get an "it 
>> works" test.
> 
> It has been tested, as stated in the changelog, and works (on my test system).


Apologies, I missed this.  I'll look to our new tulip maintainer to 
queue your resent patch, or at least ACK it...

	Jeff


