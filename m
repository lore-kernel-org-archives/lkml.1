Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXDCO33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXDCO33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030285AbXDCO32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:29:28 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23702 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbXDCO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:29:27 -0400
Date: Tue, 03 Apr 2007 08:28:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-reply-to: <fa.G7qJfhdvOynxlffny+Xc1kIaqBY@ifi.uio.no>
To: Christian Kujau <christian@g-house.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Message-id: <4612648D.4090904@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.P3upyx4QAcXHtp/c/s+b4/cKk5w@ifi.uio.no>
 <fa.u/RjoL2ybMMaAY+GDfTzm7jO5d0@ifi.uio.no>
 <fa.G7qJfhdvOynxlffny+Xc1kIaqBY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> Len et al., do you even suggest to use ACPI on a server system at all? I 
> myself always thought of ACPI being evil and to avoid when possible 
> (thus switching it off completely on a serversystem).

These days I think it's usually best to have ACPI on with current 
systems. Although it's not as bad with servers, many machines are 
designed to run only Windows (which normally always uses ACPI) and 
simply aren't tested well or at all with ACPI disabled so you can run 
into a lot of problems which are just bugs in the BIOS, etc.

Also, on the server side, if ACPI is disabled you can't take advantage 
of CPU clock frequency scaling to save power.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

