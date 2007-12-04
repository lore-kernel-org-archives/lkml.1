Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXLDUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXLDUqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXLDUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:46:34 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56798 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXLDUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:46:34 -0500
Message-ID: <4755BC97.7050607@nortel.com>
Date: Tue, 04 Dec 2007 14:46:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
References: <47548BF4.3010907@nortel.com> <20071203230629.725f4c7a@the-village.bc.nu> <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
In-Reply-To: <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2007 20:46:18.0608 (UTC) FILETIME=[B86BCF00:01C836B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:

> Magnetic drives have latencies ~10 milliseconds, current SSD's are an
> order of magnitude better (~1 millisecond), new interfaces and
> refinements could theoretically get us down one more (~100
> microsecond).

They've already done already better than that.  Here's a solid state 
drive with a claimed 20 microsecond access time:

http://www.curtisssd.com/products/drives/hyperxclr

Chris
