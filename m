Return-Path: <linux-kernel-owner+w=401wt.eu-S1767814AbXDFP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767814AbXDFP7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767815AbXDFP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:59:40 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22924 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767814AbXDFP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:59:40 -0400
Date: Fri, 06 Apr 2007 09:57:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Invalid operand: kernel BUG at mm/rmap.c:434! and
 arch/i386/mm/highmem.c:42!)
In-reply-to: <fa.UqD3AUpVhpmkJHPiQ1o5eUzIrx0@ifi.uio.no>
To: Pat <patchu1@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46166DCF.70209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.UqD3AUpVhpmkJHPiQ1o5eUzIrx0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pat wrote:
> I'm running kernel 2.6.9-22.ELsmp on dual Xeon
> servers. I've received kernel panics occasionally in
> the past, but they are more frequent now as the load
> on the system has increased. Below is a capture of the
> kernel panic. 
> 
> If anything below screams it's coming from a certain
> source (defective RAM? Bad application or device
> driver?), please let me know as I'm pulling what
> little hair I have left out on this one. Suggestions
> on what to try would be greatly appreciated. Thanks! 

First try updating to the latest RHEL update kernel, that one's out of date.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

