Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZFENkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZFENkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZFENj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:39:57 -0400
Received: from av6-2-sn3.vrr.skanova.net ([81.228.9.180]:49323 "EHLO
	av6-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZFENj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:39:56 -0400
Message-ID: <4A29202C.8060508@mocean-labs.com>
Date: Fri, 05 Jun 2009 15:39:56 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/9] Support for the Timberdale FPGA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow is a set of patches implementing some of the peripherals
on the Timberdale FPGA. The FPGA can currently be fount on the
Russellville board, which is a development board for the Intel
Atom CPU to be used for in-vehicle infotainment.

There are some patches previously sent (KS8842 (ethernet),
ADV7180 (video decoder) and TSC2003 (touch screen controller))
which are needed to fully use this board.

The drivers has been in the moblin IVI kernel for a while.

Some of the patches implements support for new hardware and some
patches existing drives.

Thanks
--Richard
