Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbXGXTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbXGXTNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXGXTNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:13:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58136 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392AbXGXTNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:13:09 -0400
Message-ID: <46A64F40.9080908@garzik.org>
Date: Tue, 24 Jul 2007 15:13:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Aaron Porter <atporter@primate.net>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
References: <20070724172513.GB24543@primate.net> <p73vec9sknz.fsf@bingen.suse.de> <20070724184908.GD24543@primate.net>
In-Reply-To: <20070724184908.GD24543@primate.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Turn off slab debugging and preempt, and see if that helps.

	Jeff



