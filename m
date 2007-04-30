Return-Path: <linux-kernel-owner+w=401wt.eu-S1423299AbXD3ObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423299AbXD3ObT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423300AbXD3ObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:31:19 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:50180 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423299AbXD3ObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:31:17 -0400
Date: Mon, 30 Apr 2007 08:30:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Nvidia nForce5 NCQ support status?
In-reply-to: <fa.ubOhv991cs61Tgo8KgKpofqr/Oc@ifi.uio.no>
To: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <4635FD7C.9030609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ubOhv991cs61Tgo8KgKpofqr/Oc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan De Luyck wrote:
> Hello list,
> 
> I was wondering what has happened with the NCQ support for nForce5 chipsets? 
> I've got one (on an Abit KN9-SLI), and I've found no further mentions about 
> it for a while.
> 
> Kind regards,
> 
> Jan

Still waiting for information or a patch from NVIDIA to implement this. 
It seems they've left those chipsets out in the cold, as we have ADMA 
support on the nForce4 and the latest 6-series chipsets apparently 
support AHCI..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

