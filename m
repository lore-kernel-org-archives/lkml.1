Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbYJJRRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbYJJRRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYJJRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:16:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:25126 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437AbYJJRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=IGa/0t049/Nj14D1qtm5E55YAZBsvMsQb+PljBEeBGtFIKiDRuW1jHv+MGh/o7LTue
         WV3iwpZYUD03Rc/nArVff+wSicjoRmbaX5zlgtdChh4TWS0JEuiA8CHbLtz5wUq9AKMU
         Bse5ecTkVJfnicBBBiMBGG79CtM+RQPlcLluE=
Message-ID: <48EF8E01.2060709@gmail.com>
Date: Fri, 10 Oct 2008 18:16:49 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Dave <kilroyd@googlemail.com>, orinoco-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810101141.38929.arvidjaar@newmail.ru> <48EF8AF4.1040900@gmail.com> <200810102114.55663.arvidjaar@newmail.ru>
In-Reply-To: <200810102114.55663.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
>> You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.
>>
> 
> Do you want me to send a patch?

Could you fix it as part of the patch you submitted?


Regards,

Dave.
