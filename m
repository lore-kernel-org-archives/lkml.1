Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbXEOANw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbXEOANw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXEOANp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:13:45 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64934 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbXEOANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:13:44 -0400
Date: Mon, 14 May 2007 18:13:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
In-reply-to: <fa.FTEkheuP0nHOUv0cCp0k8pBuoMU@ifi.uio.no>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4648FB1B.90208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FTEkheuP0nHOUv0cCp0k8pBuoMU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the radeon driver has the same problem as the i915 driver 
mentioned on the known problems page - I get 60 wakeups/sec from it on 
my Compaq X1000 laptop (Radeon 9000 graphics) while in X, which 
essentially prevents entry into C3.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

