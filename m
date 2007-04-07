Return-Path: <linux-kernel-owner+w=401wt.eu-S966105AbXDGQu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966105AbXDGQu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966109AbXDGQu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:50:59 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:29610 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966105AbXDGQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:50:58 -0400
Date: Sat, 07 Apr 2007 10:50:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Two questions regarding Opening files within Kernel!
In-reply-to: <fa.9BBqigWhVcsOIUStQ9CipWD6PQo@ifi.uio.no>
To: JanuGerman <doublemalam@yahoo.co.uk>
Cc: linuxkernel <linux-kernel@vger.kernel.org>
Message-id: <4617CBE7.5060401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.9BBqigWhVcsOIUStQ9CipWD6PQo@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

JanuGerman wrote:
> Hi Every one,
> 
>   I have got two questions regarding opening files within the Linux kernel. If some body can help me, in sorting out this problem, i will be very thankful.

First off, likely not something you should be doing:

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

