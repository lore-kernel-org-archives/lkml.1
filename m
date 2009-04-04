Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZDDP2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZDDP2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZDDP1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:27:53 -0400
Received: from gw.goop.org ([64.81.55.164]:57832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZDDP1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:27:53 -0400
Message-ID: <49D77C76.2020505@goop.org>
Date: Sat, 04 Apr 2009 08:27:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: We La <w.landgraf@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: regression : kernel error instead of automount mobile phone
References: <843756.2736.qm@web112207.mail.gq1.yahoo.com>
In-Reply-To: <843756.2736.qm@web112207.mail.gq1.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We La wrote:
>  Message from syslogd@localhost at Tue Mar 31 21:50:22 2009 ...
> localhost kernel: Code: 00 8b 45 f0 c7 86 9c 00 00 00 10 32 7e f8 89 86 90 00 00 00 8d 86 94 00 00 00 89 86 94 00 00 00 89 86 98 00 00 00 8b 02 8b 78 0c <0f> b6 47 03 83 e0 03 83 f8 03 75 06 80 7f 02 00 78 45 c7 45 dc 
>
>  Message from syslogd@localhost at Tue Mar 31 21:50:22 2009 ...
> localhost kernel: EIP: [<f87e3f9f>] wdm_probe+0x17f/0x3f0 [cdc_wdm] SS:ESP 0068:e84c5dbc
>
> =====
> Phone Sony-Ericson 
> On connecting via USB, comes the error message above. Kernel 2.6.29.  With 2.6.26.2 (all oter things the same) no problem, it automounts and opens the window with the file list.
>   

Can you collect a full oops output?  If the machine is still alive after 
the oops, you can get it with dmesg.

    J
