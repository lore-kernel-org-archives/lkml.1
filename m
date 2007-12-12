Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXLLPAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXLLPAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbXLLPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:00:28 -0500
Received: from rtr.ca ([76.10.145.34]:4113 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbXLLPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:00:26 -0500
Message-ID: <475FF788.5000906@rtr.ca>
Date: Wed, 12 Dec 2007 10:00:24 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Anas Nashif <nashif@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com> <20071211185317.GA21864@one.firstfloor.org> <475EDFA3.1070001@linux.intel.com>
In-Reply-To: <475EDFA3.1070001@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anas Nashif wrote:
>
> Actually no TCP/IP is needed here. Basically the MEI driver writes and reads the
> messages to/from the firmware. When communicating in-band using LMS, TCP/IP
> terminates at LMS and the messages are copied using MEI driver.
> 
>>> To have a feel for all of this, with many examples, samples and documentation
>>> you can download the AMT 3.0 SDK (google: intel amt sdk).
>> I would be more interested right now how the kernel can use this without
>> additional user space support. Any ideas on this? 
> 
> I will dig for some documents on that.
..

Sample code for storing a trace_back() would be much better.

-ml
