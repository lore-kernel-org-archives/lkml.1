Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbYFMLHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbYFMLHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYFMLHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:07:00 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:33645 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYFMLG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:06:59 -0400
Message-ID: <485254CA.7080202@diamondcut.com.br>
Date: Fri, 13 Jun 2008 08:06:50 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, devzero@web.de
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br> <20080602192012.GA7748@ucw.cz> <4846744A.9040204@diamondcut.com.br> <484D10DE.30704@diamondcut.com.br> <20080611103330.GA5612@ucw.cz>
In-Reply-To: <20080611103330.GA5612@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Renato S. Yamane wrote:
>> Pavel Machek wrote:
>>> does it still happen with acpi=off?
>>
>> With acpi=off this problem don't happening, but a lot of other problem
>> happening (as fan control).
>>
>> If I hold power button to force shutdown I don't have this problem with
>> battery charge.
> 
> Too bad, I can't call the hw terminally broken, then.
> 
> If you boot into init=/bin/bash (minimum drivers) will it still
> consume too much power after sysrq-o?

I hold power button to force shutdown and start with init=/bin/bash, but
this problem still exist :-(

You know about this?:
<http://linux.toshiba-dme.co.jp/linux/eng/develop.htm>

Best regards,
Renato S. Yamane
