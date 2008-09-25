Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYIYVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYIYVSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYIYVR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:17:57 -0400
Received: from ool-44c4e8e5.dyn.optonline.net ([68.196.232.229]:53512 "EHLO
	pc-feiliu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756131AbYIYVR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:17:56 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 17:17:56 EDT
Message-ID: <48DBFA43.6030105@gmail.com>
Date: Thu, 25 Sep 2008 16:53:23 -0400
From: Fei Liu <feiliu4@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080317 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: A question to Frank Kingswood about ch340/341 support for 2.4.18
 kernel
References: <47E9B6A9.6010408@gmail.com> <alpine.LNX.1.10.0803260424130.22661@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803260424130.22661@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>
> On Wednesday 2008-03-26 03:36, Fei Liu wrote:
>>
>> Is there any chance this driver [ch341] can be back ported to
>> 2.6.18 for opensuse 10.2 system? It seems the usb kernel data
>> structures had some significant changes from 2.6.18 to 2.6.24.
>
> They indeed have, and probably not insignificant.
>
> ftp://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3/ (and
> ../SRPMS/) contains ch341-2.6.23.99rc7-1593.{i586,x86_64,src}.rpm for
> 2.6.23(.17) (and such kernel is available through this repository).
> Maybe it helps though you said you have 10.2.
>
Hi Jan, thanks for the info. I didn't find this gem until today when I 
am cleaning up my emails...

Cheers,

Fei
