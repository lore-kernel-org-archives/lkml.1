Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYDZObP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYDZObP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYDZObB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:31:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58278 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYDZObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:31:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48133C9B.9060204@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 16:30:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb over ethernet?
References: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr> <481215B7.9020503@windriver.com>
In-Reply-To: <481215B7.9020503@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan Engelhardt wrote:
>> the DocBook files for the recently-merged kgdb mention kgdboe, as does 
>> the doc on kgdb.sf.net, but I do not see kgdboe anywhere in the source. 
>> Is oe actually merged? I'm kinda short on rs232...

Not what you asked for, but... perhaps you have a spare FireWire port?
>From Documentation/debugging-via-ohci1394.txt:

| There is also a gdb proxy for firewire which allows to use gdb to
| access data which can be referenced from symbols found by gdb in
| vmlinux:
| - ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
|
| The latest version of this gdb proxy (fireproxy-0.34) can communicate
| (not yet stable) with kgdb over an memory-based communication module
| (kgdbom).
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
