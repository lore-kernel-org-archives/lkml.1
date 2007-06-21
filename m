Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbXFUOYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbXFUOYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXFUOXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:23:52 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:16766 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXFUOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:23:51 -0400
Date: Thu, 21 Jun 2007 08:23:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Dual slot PCI riser messes up ivtv
In-reply-to: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no>
To: pharon@gmail.com
Cc: linux-kernel@vger.kernel.org
Message-id: <467A89D4.6080607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Islam Amer wrote:
> Hello everyone.
> 
> I am trying to build a settop box with two cards, a PVR-150 and a DVB
> card. The mini-ITX motherboard has only one PCI slot, so I bought an
> active PCI riser.
> 
> First I tried with two cheap lifeview cards on the riser and they
> worked.
>  
> The PVR-150 is working fine alone, and so does the DVB card. But when I
> use them with the riser nothing works.

Please post the output of lspci -vvv with the cards installed in the riser.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

