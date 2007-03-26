Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXCZHtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXCZHtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXCZHtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:49:24 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1308 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbXCZHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:49:24 -0400
Message-ID: <46077AEE.8060507@shadowen.org>
Date: Mon, 26 Mar 2007 08:49:02 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: debug rsdl 0.33
References: <20070319205623.299d0378.akpm@linux-foundation.org> <64bb37e0703251128q3f9db894u24c4638dcf97224a@mail.gmail.com> <200703260849.07943.kernel@kolivas.org> <200703260859.27272.kernel@kolivas.org>
In-Reply-To: <200703260859.27272.kernel@kolivas.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:

> This is about the only place I can see the run_list is looked at unlocked. Can
> you see if this simple patch helps? The debug patch is unnecessary now.

Tests queued with this patch.  Will let you know.

-apw
