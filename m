Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXDZXYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXDZXYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXDZXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:24:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58723 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXDZXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:24:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46313416.4000102@s5r6.in-berlin.de>
Date: Fri, 27 Apr 2007 01:21:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: trivial@kernel.org, linux1394-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ohci1394: Fix mistake in printk message.
References: <462E8869.2060804@simon.arlott.org.uk>
In-Reply-To: <462E8869.2060804@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> Fix the "attempting to setting" message in ohci1394.

Committed to linux1394-2.6.git and queued for merge.
-- 
Stefan Richter
-=====-=-=== -=-- ==-==
http://arcgraph.de/sr/
