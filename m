Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbXLEOed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbXLEOed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXLEOe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:34:26 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46879 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbXLEOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:34:25 -0500
Date: Wed, 05 Dec 2007 08:34:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Timers SMP] can this machine be helped?
In-reply-to: <Pine.LNX.4.64.0712050746500.29290@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <4756B6EC.1000103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./nzsMVb44+6c2x42WGfe04SPDrY@ifi.uio.no>
 <47560A98.9080700@shaw.ca> <Pine.LNX.4.64.0712050746500.29290@axis700.grange>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Tue, 4 Dec 2007, Robert Hancock wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> I've got an old 2xP-II @ 400MHz Compaq AP400 system, which I'm still using.
>>> It has many peculiarities, so, I wouldn't be surprised if the answer to my
>>> questions would be "sorry, the patient is rather dead than alive".
>> How about disabling ACPI entirely, acpi=off on kernel command line? I wouldn't
>> be surprised to see a lot of ACPI stuff broken on an older machine like that..
> 
> See above - it's an SMP.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

On a machine that old, you shouldn't need ACPI to detect both CPUs, it 
should be able to use MPS..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

