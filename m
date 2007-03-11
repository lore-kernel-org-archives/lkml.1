Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXCKTaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXCKTaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965060AbXCKTaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:30:46 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:60204 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055AbXCKTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:30:45 -0400
Date: Sun, 11 Mar 2007 20:21:55 +0100
Message-Id: <257869058@web.de>
MIME-Version: 1.0
From: kaspro@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: I2O block driver broken in kernel 2.6.19?
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...same here. Until 2.6.18 working fine...
Thanks

>> On Fri, 23 Feb 2007 22:57:27 +0000 (UTC) Mark Gray <mvg001@xxxxxxxxxxxxx> wrote:
>> > i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
>> > Buffer I/O error on device i2o/hda, logical block 0
>>
>> Same error here. Both 2.6.19 and 2.6.20 kernels, using Adaptec 2400A RAID.

>Is Adaptec 2400 controlled by drivers/message/i2o? I assume so...

>If so, thats's at least three people reporting breakage in 2.6.19 and later.

>Is anyone able perform a git-bisect to identify the offending commit? It
>would really help.

>Thanks.
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

