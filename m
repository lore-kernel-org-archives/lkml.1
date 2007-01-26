Return-Path: <linux-kernel-owner+w=401wt.eu-S1030693AbXAZA70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030693AbXAZA70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXAZA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:59:26 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56530 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030693AbXAZA7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:59:25 -0500
Date: Thu, 25 Jan 2007 18:57:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: linux i386 kernel 2.4.16 2.4.22 scheduling issue?
In-reply-to: <fa.vvOWc9w2lXOSM85ZYU7DBK5SiSI@ifi.uio.no>
To: Fei Liu <feiliu@aepnetworks.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45B95213.5060202@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vvOWc9w2lXOSM85ZYU7DBK5SiSI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fei Liu wrote:
> Hello group, I have some concern about scheduling issue with 2.4.16 and 
> 2.4.22 i386 kernel where I see 1200+ interrupts and context switches per 
> second through vmstat when machine is under load. Is this behavior 
> normal? Is there any know scheduling issue with the above mentioned 
> kernel versions?

That number doesn't seem too unusual..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

