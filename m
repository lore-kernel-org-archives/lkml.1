Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYAXHQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYAXHQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYAXHQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:16:26 -0500
Received: from xdsl-9553.wroclaw.dialog.net.pl ([84.40.234.81]:49016 "HELO
	mail.alfa-net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752175AbYAXHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:16:25 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 02:16:25 EST
Message-ID: <479839B4.3060202@gmail.com>
Date: Thu, 24 Jan 2008 08:09:40 +0100
From: Marcin Gil <marcin.gil@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk>
In-Reply-To: <20080123234639.025cc859@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I have SATA drive connected to SATA0 and Maxtor IDE drive + DVD burner 
>> connected to single IDE slot.
>>
>> Booting this kernel off the SATA drive works perfectly, however the IDE drive 
>> is not found/put into /dev. However the DVD is properly recognized and 
>> created as sr0.
>>
>> Is this known problem? I've looked all over google and found out that people 
>> have problems with CD/DVD drives with pata_jmicron but in my case DVD is 
>> working ok but HDD is not.
>>
>> Is there a solution for this or can I give you more information to help me 
>> solve this?
> 
> The output of dmesg after the boot would be a good start

Here it is:
http://pastebin.com/md726431

Thank you very much!
-Marcin Gil

