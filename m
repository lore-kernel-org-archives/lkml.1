Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXJ3AFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXJ3AFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXJ3AFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:05:16 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21875 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXJ3AFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:05:15 -0400
Date: Mon, 29 Oct 2007 18:07:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Page-Out of RO data
In-reply-to: <1193653437.459747.310350@y27g2000pre.googlegroups.com>
To: vicky <vsachdeva@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <472675AF.2050001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1193653437.459747.310350@y27g2000pre.googlegroups.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vicky wrote:
> Hi,
> Can Read-Only(RO) Section/Data of kernel can ever be paged out memory?
> 
> -Vicky
> 

All kernel code and data is non-swappable in Linux..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

