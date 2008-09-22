Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbYIVHHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYIVHHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIVHH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:07:26 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:47599 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYIVHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:07:26 -0400
Message-ID: <48D74431.8050805@yahoo.com>
Date: Mon, 22 Sep 2008 08:07:29 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: George Nychis <gnychis@cmu.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: printing current system time from kernel space
References: <48D72AAD.3000805@cmu.edu>
In-Reply-To: <48D72AAD.3000805@cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 749085be226b19ad222f2064b01998b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Nychis wrote:
> I spent some time googling, but could not find out how or if it is 
> possible to read the current system time in kernel space.  I could 
> insert a printk() somewhere in usbdev_read() then.

If that's what you want to do could you not turn on timestamps on printk 
(CONFIG_PRINTK_TIME in the kernel hacking menu)?

-- 
Sitsofe | http://sucs.org/~sits/
