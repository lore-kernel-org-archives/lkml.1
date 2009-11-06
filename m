Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZKFMj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZKFMj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 07:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbZKFMj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 07:39:27 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64415 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbZKFMjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 07:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dl89vyUCkIjeHWYBK575N38MnhUrdr5cAFQSzB279Rg5qpc45LVe4I6X5z7DYM8HZE
         zhHF2aeux5U2l+8A4VcIhgN+uvmwbh6t9GSGmrY+7yfo96eNOfCBMEcM6ReN28ucrO/E
         LySyNYtfF0cAvFlfjNK0v36/HjcBoIcjtx6Js=
MIME-Version: 1.0
In-Reply-To: <661de9470911060338q66746acbr219eedc24e752ca9@mail.gmail.com>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	 <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
	 <661de9470911060338q66746acbr219eedc24e752ca9@mail.gmail.com>
Date: Fri, 6 Nov 2009 19:39:30 +0700
Message-ID: <c1f41c620911060439j42329608u74f937ac9f9ac617@mail.gmail.com>
Subject: Re: mmotm 2009-11-01-10-01 uploaded
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 6:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Fri, Nov 6, 2009 at 12:43 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Sun, 1 Nov 2009, akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>
>> Does "soon" mean within this century ?
>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>
>> # git pull git://git.zen-sources.org/zen/mmotm.git master
>> git.zen-sources.org[0: 216.98.141.250]: errno=Connection timed out
>> git.zen-sources.org[0: 69.72.142.98]: errno=Connection refused
>> fatal: unable to connect a socket (Connection refused)
>>
> I've seen that too, in fact I can't even reach the domain. I've pinged
> the owner but not heard back yet.


FTR, it moved to git://zen-kernel.org/kernel/mmotm.git and the
ownership has changed.
