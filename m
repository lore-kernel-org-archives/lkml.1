Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXGCP70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXGCP70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbXGCP7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:59:17 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:40185 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbXGCP7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:59:16 -0400
Message-ID: <468A724D.6070908@nortel.com>
Date: Tue, 03 Jul 2007 11:59:09 -0400
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060130 Red Hat/1.7.12-1.4.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 15:59:11.0438 (UTC) FILETIME=[189CC6E0:01C7BD8B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fortier,Vincent [Montreal] wrote:
> Hi all,
> 
> All my servers and workstations running a 2.6.21.5 kernel hanged exactly
> when the date shift from june 30th to july 1st.

Interesting, I just sent out an email for a similar issue, but with a pair of 
2.6.10 machines.

I'm wondering if its related to a spurious leap second event...

Chris
