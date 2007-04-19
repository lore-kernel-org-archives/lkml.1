Return-Path: <linux-kernel-owner+w=401wt.eu-S2993211AbXDSKsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993211AbXDSKsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 06:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993226AbXDSKsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 06:48:21 -0400
Received: from mail.syneticon.net ([213.239.212.131]:44919 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993211AbXDSKsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 06:48:20 -0400
X-Greylist: delayed 1922 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 06:48:20 EDT
Message-ID: <4627412D.5010504@wpkg.org>
Date: Thu, 19 Apr 2007 12:15:09 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: lwp@mail.msen.com, linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG, tulip, 2.6.18
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I also have recurrent problems with
 > NETDEV WATCHDOG: eth0: transmit timed out

I remember having it with some older kernels on Fujitsu-Siemens Scenic 
machines.

If you search the list, you'll find several similar reports about the 
tulip driver (NETDEV WATCHDOG: eth0: transmit timed out).


Adding nopaic/nolapic/noacpi options to the kernel command line helped 
in my case.


-- 
Tomasz Chmielewski
http://wpkg.org
