Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKMNNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKMNNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYKMNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:12:57 -0500
Received: from xylophone.i-cable.com ([203.83.115.99]:34571 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751658AbYKMNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:12:56 -0500
Message-ID: <008201c94591$870d73b0$0a01a8c0@kylecea1512a3f>
From: "kyle" <kylewong@southa.com>
To: "Rahul Pydimukkala" <prahul@cse.iitk.ac.in>
Cc: <linux-kernel@vger.kernel.org>
References: <009401c9454c$6e3a8610$b902a8c0@kyle> <20081113143404.GC12750@csews22.cse.iitk.ac.in> <001f01c94585$799bf280$0a01a8c0@kylecea1512a3f> <20081113191241.GB14953@csews22.cse.iitk.ac.in>
Subject: Re: apache threads not balanced over all CPU cores, schedular problem or apache?
Date: Thu, 13 Nov 2008 21:12:45 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rahul Pydimukkala" <prahul@cse.iitk.ac.in>
To: "kyle" <kylewong@southa.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Friday, November 14, 2008 3:12 AM
Subject: Re: apache threads not balanced over all CPU cores, schedular 
problem or apache?


> Few of the cores are always left idle by default for power saving reasons.
> There has been a discussion over it sometime back. 
> http://lkml.org/lkml/2008/6/25/326
>
> That helps you play around with the load-balancer.
>

Oh I never note this.

However, my current setting is "0".

Regards,
Kyle

