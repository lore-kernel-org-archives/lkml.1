Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbXH1FQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbXH1FQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbXH1FQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:16:14 -0400
Received: from smtp.nokia.com ([131.228.20.173]:37442 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXH1FQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:16:13 -0400
Message-ID: <46D3AF72.7030701@nokia.com>
Date: Tue, 28 Aug 2007 08:15:30 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700
 system
References: <46C9D148.5080505@nokia.com>
In-Reply-To: <46C9D148.5080505@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2007 05:15:30.0755 (UTC) FILETIME=[74063930:01C7E932]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stefan Becker wrote:
> 
> while trying to debug a hibernation/rtc_cmos alarm wakeup problem in 
> 2.6.22 (or later) I noticed that the latest kernel crashes (or gets 
> stuck sometimes) during boot after the message:
> 
> SMP alternatives: switching to UP code

Retested with 2.6.23-rc3-git10. Same result :-/

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
