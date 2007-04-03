Return-Path: <linux-kernel-owner+w=401wt.eu-S1945978AbXDCVbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945978AbXDCVbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945977AbXDCVbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:31:09 -0400
Received: from bay0-omc1-s11.bay0.hotmail.com ([65.54.246.83]:56338 "EHLO
	bay0-omc1-s11.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945978AbXDCVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:31:07 -0400
Message-ID: <BAY20-F2534ADD292CC02D5ACAFBCF9670@phx.gbl>
X-Originating-IP: [88.114.147.249]
X-Originating-Email: [paapaa125@hotmail.com]
In-Reply-To: <46121BCF.50401@yahoo.com.au>
From: "Paa Paa" <paapaa125@hotmail.com>
To: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
Date: Tue, 03 Apr 2007 21:31:04 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 03 Apr 2007 21:31:06.0994 (UTC) FILETIME=[639E3520:01C77637]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>Q: What conclusion can I make on "hdparm -t" results or can I make any 
>>conclusions? Do I really have lower performance with NCQ or not? If I do, 
>>is this because of my HD or because of kernel?
>
>What IO scheduler are you using? If AS or CFQ, could you try with deadline?

I was using CFQ. I now tried with Deadline and that doesn't seem to degrade 
the performance at all! With Deadline I got 60MB/s both with and without 
NCQ. This was with "hdparm -t".

So what does this tell us?

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

