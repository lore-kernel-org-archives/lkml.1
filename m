Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYLOUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYLOUz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYLOUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:55:19 -0500
Received: from wp093.webpack.hosteurope.de ([80.237.132.100]:53245 "EHLO
	wp093.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856AbYLOUzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:55:18 -0500
X-Greylist: delayed 1569 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 15:55:17 EST
Message-ID: <4946BE11.5080501@romal.de>
Date: Mon, 15 Dec 2008 21:29:05 +0100
From: "Robert M. Albrecht" <mail@romal.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; de; rv:1.9.1b3pre) Gecko/20081201 Thunderbird/3.0b1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: philipl@overt.org
Subject: Bug 10173 / Bluetooth on Toshiba & Compal laptops
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;mail@romal.de;1229374518;e28dec76;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

anyone working on toshiba_acpi or omnibook module ?

toshiba_acpi:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=c41a40c58b623f97dd2e23aa3baab2cedb47d99f

The rfkill-switch does not work. The device is disabled when switched of, 
but it gets not reenabled. But the bluetooth dongle is enabled after booting.

AFAIK this only works for Toshiba manufactured devices (toshiba_acpi), not 
for Compal manufactured.

Omnibook:

Omnibook module functionality for Compal manufactured lptops should still 
be included in the kernel. The Compal supporting module omnibook 
additionaly works on many laptops from HP, ... The omnibook-module seems to 
be abandoned, the last commit is nearly two years ago.

Omnibook-module: http://sourceforge.net/projects/omnibook

cu romal

www.romal.de
blog.romal.de
