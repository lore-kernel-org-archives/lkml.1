Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXI1MST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXI1MST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXI1MSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:18:09 -0400
Received: from mail.syneticon.net ([213.239.212.131]:33814 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXI1MSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:18:08 -0400
Message-ID: <46FCF0F5.9030004@wpkg.org>
Date: Fri, 28 Sep 2007 14:17:57 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Miguel <mc354@tid.es>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: software unplug and plug USB
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm using a huawei E220 modem and occasionally it doesn't work and I
> must unplug and plug it again, run the scripts connection to make it
> works again.
> how can I unplug an plug an USB modem via software?

If the modem doesn't have any other power sources than USB, just 
removing the modem's and USB modules, and the modprobing them again 
should help.

Just take care if you have it connected to the PC with a USB keyboard ;)


-- 
Tomasz Chmielewski
http://blog.wpkg.org

