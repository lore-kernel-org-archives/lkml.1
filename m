Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbZANO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbZANO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760673AbZANO5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:57:18 -0500
Received: from sd-green-bigip-66.dreamhost.com ([208.97.132.66]:56775 "EHLO
	spunkymail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759719AbZANO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:57:18 -0500
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 09:57:17 EST
Message-ID: <496DFD45.5030408@dawes.za.net>
Date: Wed, 14 Jan 2009 16:57:09 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk> <20090114101828.GA15141@frolo.macqel> <496DF66B.3050609@dawes.za.net> <20090114145239.GB21043@frolo.macqel>
In-Reply-To: <20090114145239.GB21043@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Wed, Jan 14, 2009 at 04:27:55PM +0200, Rogan Dawes wrote:
>> Philippe De Muyter wrote:
>>
>>> Keeping thinking about it, I now think that my 'application program'
>>> (basically a serial-to-ethernet converter) should be a kernel thread,
>>> because of the small memory constraints.
>>>
>>> The question is thus how to access the serial lines from a kernel thread.
>>>
>>> Philippe
>> If your constraints are that severe, perhaps you should be investigating
>> other solutions. e.g. eCos?
> 
> I like to reuse (and contribute to) the linux drivers and kernel.
> 
>> Linux doesn't ALWAYS have to be the answer :-)
> 
> No ? :)
> 
> Philippe
> 

Ok, in that case, perhaps you should explain exactly what your
constraints are (target board, max memory/flash, etc), and maybe folks
will be able to provide more sensible answers.

Good luck!

Rogan
