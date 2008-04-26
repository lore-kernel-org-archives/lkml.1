Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYDZPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYDZPDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYDZPDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:03:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50150 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYDZPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:03:07 -0400
Date: Sat, 26 Apr 2008 17:03:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb over ethernet?
In-Reply-To: <48133C9B.9060204@s5r6.in-berlin.de>
Message-ID: <alpine.LNX.1.10.0804261701400.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr> <481215B7.9020503@windriver.com> <48133C9B.9060204@s5r6.in-berlin.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-04-26 16:30, Stefan Richter wrote:

>> Jan Engelhardt wrote:
>> > the DocBook files for the recently-merged kgdb mention kgdboe, as does the
>> > doc on kgdb.sf.net, but I do not see kgdboe anywhere in the source. Is oe
>> > actually merged? I'm kinda short on rs232...
>
> Not what you asked for, but... perhaps you have a spare FireWire port?

Not either. But see 
http://jengelh.medozas.de/2008/0425-vmware-serial.php for the prime 
solution that I have working now.
