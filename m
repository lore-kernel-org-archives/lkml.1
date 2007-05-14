Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXENWKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXENWKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbXENWKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:10:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44469 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXENWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:10:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4648DE37.2080505@s5r6.in-berlin.de>
Date: Tue, 15 May 2007 00:09:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr> <4648A3DF.7040004@imap.cc> <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr> <4648D74C.6010305@imap.cc>
In-Reply-To: <4648D74C.6010305@imap.cc>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 14.05.2007 22:33 schrieb Jan Engelhardt:
>>   * Disabling this menu disables all the fluff inside it,

except when it doesn't.

> Another essential piece of information. I seem to remember other
> menus which, when disabled, kept the selection status of the
> options inside and just hid them from view.

It's a matter of /dependence/ on a menuconfig option whether options
inside the menu will be disabled.  Not a matter of being located in the
menu.

If menuconfig isn't used with strict discipline, we end up with
inconsistent and misleading presentation of the kernel configuration.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
