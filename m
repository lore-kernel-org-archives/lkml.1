Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXA2Py5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXA2Py5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXA2Py5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:54:57 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:56218 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbXA2Py5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:54:57 -0500
Message-ID: <45BE18C9.6080200@cfl.rr.com>
Date: Mon, 29 Jan 2007 10:54:49 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: vger truncating CC lists
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2007 15:55:06.0051 (UTC) FILETIME=[D8527130:01C743BD]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14964.003
X-TM-AS-Result: No--6.599100-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that vger seems to be truncating Cc lists lately, often 
resulting in broken partial email addresses in the Cc list causing 
people that reply to have copies of the message bounced back instead of 
being delivered to the intended recipients.  It seems that it munges 
long, multi line Cc headers into one line, and truncates that line to a 
maximum length.  Who is the list admin again?  And can they look into this?

