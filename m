Return-Path: <linux-kernel-owner+w=401wt.eu-S935007AbZAOXba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935007AbZAOXba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763655AbZAOXbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:31:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41985 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762057AbZAOXbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:31:20 -0500
Message-ID: <496FC746.8080908@sgi.com>
Date: Thu, 15 Jan 2009 15:31:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Dieter Ries <clip2@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>	 <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com>	 <496FA4B6.3000607@gmx.de>	 <8db1092f0901151348l47ffcec7m638180ca2cdbe4ce@mail.gmail.com>	 <496FB0A5.6050004@sgi.com> <8db1092f0901151504h4d8f9234q4b06522149c54af4@mail.gmail.com>
In-Reply-To: <8db1092f0901151504h4d8f9234q4b06522149c54af4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/1/15 Mike Travis <travis@sgi.com>:
> 
>> And it works ok without my patch?  Drats!  ;-)
>>
>> I'll see if I can't figure out how to debug it here.
>>
>> Thanks!
>> Mike
>>
> 
> To be clear:
> 2.6.29-rc1-git5:
> s2disk: hang
> s2ram: resume immediately and hangs
> 
> 2.6.29-rc1-git5+ Your patches (3):
> s2disk: works OK
> s2ram: resume immediately and hangs

Cool, thanks!  (I guess that's good news for me... 
not so good for you. ;-)

Mike
