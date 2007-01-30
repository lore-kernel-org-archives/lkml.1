Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXA3XgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXA3XgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXA3XgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:36:01 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:54019 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXA3XgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:36:00 -0500
Date: Tue, 30 Jan 2007 17:35:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Free Linux Driver Development!
In-reply-to: <fa.T1Mpk9x9o81uajHKj9J8RE8yM2c@ifi.uio.no>
To: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>
Message-id: <45BFD64F.806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vy0GBdNvEFvgi9ipVzdiBp0FpjI@ifi.uio.no>
 <fa.INRmyia9BGp5I+SBT3+o7eNe+vo@ifi.uio.no>
 <fa.JOovioFiqyKNIa9g0QxNLn/pldw@ifi.uio.no>
 <fa.f1ctPsEcBEc59B+Sd5oTTUfDmIs@ifi.uio.no>
 <fa.OyKqe20gDjwobkBZicjVmJ5DPp8@ifi.uio.no>
 <fa.T1Mpk9x9o81uajHKj9J8RE8yM2c@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>> I guess Nvidia ADMA is pretty much
>> done now.
> 
> Yep.  Without docs, even.  And its supported by enterprise distros.

Well, the "docs" I was using was a half-finished, broken version of the 
driver released by NVidia which had to be significantly revised, and the 
public ADMA spec which the hardware was vaguely based on and which a few 
things could be inferred from. If NVidia had just released the docs it 
would have been much easier, I would have gladly written it from 
scratch. There are still things in the driver that could likely be 
improved if we had the actual hardware documents, registers that we 
don't know what half the bits are for, etc.

Having the vendor release a driver without hardware information is fine, 
as long as it works perfectly or they maintain it when bugs are found. 
Otherwise, anyone else trying to fix it will end up with an exercise in 
"why was it doing this? should it be doing this instead?"

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

