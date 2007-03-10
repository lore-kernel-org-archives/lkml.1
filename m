Return-Path: <linux-kernel-owner+w=401wt.eu-S1767856AbXCJQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767856AbXCJQW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767864AbXCJQW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:22:26 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8266 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767856AbXCJQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:22:25 -0500
Date: Sat, 10 Mar 2007 10:21:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: How soon is soon? MCP55 NCQ support on Linux...
In-reply-to: <fa.KSn1DWJ+5WP0YQT6/PSMt6AbHU8@ifi.uio.no>
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Allen Martin <AMartin@nvidia.com>
Message-id: <45F2DB1B.7040305@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.KSn1DWJ+5WP0YQT6/PSMt6AbHU8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltan Boszormenyi wrote:
> Hi,
> 
> I have seen your message in LKML archive:
> http://marc.theaimsgroup.com/?l=linux-kernel&m=116046278930988&w=2
> It's dated 2006.10.10 and states that a patch
> to support NCQ on MCP55/MCP61 under Linux
> is coming "soon". Now it's five months later
> and I would like to ask when will it be supported?
> Especially when this seems to be the last NVidia chipset
> that has NCQ but isn't supported under Linux.
> 
> Thanks in advance,
> Zoltán Böszörményi

It's a good question, I haven't heard anything about this either. Even 
documentation to allow others to implement it would be useful, although 
there may be some kind of IP issues that prevent public release of the 
specs, as I assume has prevented this with the nForce4 ADMA controllers.

I'm not sure what the story is with MCP51 either.. apparently the 
Windows driver NCQ support for that chipset was late in coming but I 
think it does have it now too..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

