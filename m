Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXAZOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXAZOhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030658AbXAZOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:37:10 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11648 "EHLO
	pd5mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXAZOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:37:09 -0500
Date: Fri, 26 Jan 2007 08:35:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA
 unstability problems on ASUS A8Js
In-reply-to: <fa.ZnWRVfns13JT5BT7zPCIOVH11yw@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Martin Drab <drab@kepler.fjfi.cvut.cz>,
       Oleg Verych <olecom@flower.upol.cz>
Message-id: <45BA11BD.8070504@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PpxpQ7nMZSyaD7q+Ht9cGg0CIiw@ifi.uio.no>
 <fa.wqPyXXdyh/mi1huaDG6ytwgWGls@ifi.uio.no>
 <fa./T3sQPFQFuD91GZzkxPLpnq+daI@ifi.uio.no>
 <fa.pgpxy1bTTJGfmjQzrCFr6RYyJZ8@ifi.uio.no>
 <fa.ZnWRVfns13JT5BT7zPCIOVH11yw@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Drab wrote:
>>> Hmm, it may be. Was there suggested any solution (or at least proposal) 
>>> that I may try?
>> Try fix BIOS bugs: <http://permalink.gmane.org/gmane.linux.kernel/462632>
> 
> ASUS refused to help fixing the BIOS with words that ASUS notebooks do not 
> support Linux. So if we do not workaround this somehow, Linux would really 
> be unusable on this HW. :(

Vendors really need to realize that even if they don't care about Linux, 
not fixing these bugs will only hurt them with future Windows versions 
when it suddenly starts caring about MMCONFIG support..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

