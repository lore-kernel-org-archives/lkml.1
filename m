Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYAEUlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYAEUlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYAEUlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:41:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46712 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYAEUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:41:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <477FEB4B.9090804@s5r6.in-berlin.de>
Date: Sat, 05 Jan 2008 21:40:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet>
In-Reply-To: <200801051546.SAA08947@raad.intranet>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> -comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
> -	depends on USB
> -comment "also be needed; see USB_STORAGE Help for more information"
> -	depends on USB

Your patch description fails to mention what is wrong with the existing
solution.
-- 
Stefan Richter
-=====-==--- ---= --=-=
http://arcgraph.de/sr/
