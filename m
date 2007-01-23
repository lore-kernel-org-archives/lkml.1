Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbXAWBnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbXAWBnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbXAWBnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:43:43 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63424 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbXAWBnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:43:42 -0500
Date: Mon, 22 Jan 2007 19:41:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
In-reply-to: <200701230134.57775.s0348365@sms.ed.ac.uk>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       Jeff Garzik <jeff@garzik.org>, Chr <chunkeey@web.de>,
       linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       lwalton@real.com, pomac@vapor.com
Message-id: <45B567DF.1050008@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no>
 <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no> <45B563C6.5070505@shaw.ca>
 <200701230134.57775.s0348365@sms.ed.ac.uk>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Tuesday 23 January 2007 01:24, Robert Hancock wrote:
>> As a final aside, this is another case where the hardware docs for this
>> controller would really be useful, in order to know whether we are
>> actually supposed to be reading that register in ADMA mode or not. I
>> sent a query to Allen Martin at NVIDIA asking if there's a way I could
>> get access to the documents, but I haven't heard anything yet.
> 
> Obviously, NVIDIA's response is disappointing, but thank you for putting the 
> time in to debug this problem. Definitely sounds like a hardware defect, I'm 
> just glad there's a workaround.
> 
> Will we see this fix in 2.6.20?

Hopefully, assuming it actually does fix the problem for those that have 
been seeing it..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

