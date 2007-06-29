Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXF2XTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXF2XTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 19:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXF2XTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 19:19:09 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23340 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbXF2XTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 19:19:08 -0400
Date: Fri, 29 Jun 2007 17:18:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel doesn't recognize complete memory
In-reply-to: <fa.8WY71RLqV3Tqf8TkTOMOg/ub4Cs@ifi.uio.no>
To: Frank Fiene <ffiene@veka.com>
Cc: linux-kernel@vger.kernel.org, tytso@thunk.org
Message-id: <46859340.7020206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8WY71RLqV3Tqf8TkTOMOg/ub4Cs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Fiene wrote:
> Lenovo Z61p, Intel Core2 Duo T7200
> 
> I have 4GB RAM installed and BIOS recognize 4GB RAM.
> Linux kernel (Ubuntu-7.04, 32bit-PAE and 64bit, openSUSE-10.2 32bit-PAE 
> and 64bit) tells me: only 3GB of RAM are installed.
> 
> Any other user with a 4GB Thinkpad? tytso?
> 
> What can i do? Please help!
> 
> Regards
> Frank

Please post your bootup dmesg output. If your chipset doesn't support 
memory remapping above 4GB or the BIOS doesn't enable it, you won't be 
able to use all 4GB of memory.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

