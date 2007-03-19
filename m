Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXCSUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXCSUZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXCSUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:25:36 -0400
Received: from smtp.nokia.com ([131.228.20.171]:23264 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXCSUZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:25:34 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Matt Mackall <mpm@selenic.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319195442.GT4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Mar 2007 22:18:32 +0200
Message-Id: <1174335512.17249.17.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Mar 2007 20:18:32.0972 (UTC) FILETIME=[C438ECC0:01C76A63]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070319221845-7A82DBB0-0CDBAFB1/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> The issue is 14000 lines of patch to make a parallel subsystem.

It'll be much smaller after I remove "itsy-bitsy" and most of the
debugging stuff, in progress - wait for take 4.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

