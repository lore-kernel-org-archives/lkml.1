Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZGWSQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZGWSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZGWSQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:16:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:23232 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbZGWSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:16:40 -0400
Message-ID: <4A68A8D9.1020207@nokia.com>
Date: Thu, 23 Jul 2009 21:15:53 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       David Vrabel <david.vrabel@csr.com>, marek.vasut@gmail.com,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>	 <4A6701E3.3000204@csr.com> <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com> <4A68709E.5060207@csr.com>
In-Reply-To: <4A68709E.5060207@csr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 18:15:18.0491 (UTC) FILETIME=[88C86AB0:01CA0BC1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Have you considered using our enable/disable approach instead?

It is here:

http://groups.google.com/group/linux.kernel/browse_frm/thread/a5caec1de1274be5/2ba7dee2a187a268

Perhaps it meets your needs, whereas your patches do not seem
to cover the functionality we need.

Regards
Adrian Hunter
