Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbXHZWwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbXHZWwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964786AbXHZWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:52:04 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:58370 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932107AbXHZWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:52:02 -0400
Message-ID: <46D20407.5060804@mandic.com.br>
Date: Sun, 26 Aug 2007 19:51:51 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Compiling 2.6.22.5 on Debian Etch (internal compiler error)
References: <46D1FA57.60601@mandic.com.br> <9a8748490708261520h74e97bb5sc486b1cf8294c686@mail.gmail.com>
In-Reply-To: <9a8748490708261520h74e97bb5sc486b1cf8294c686@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl escreveu:
> On 27/08/07, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
>> Can someone help me with this?
>>
>> $ make xconfig
>> HOSTCC  scripts/basic/fixdep
>> scripts/basic/fixdep.c: In function 'parse_dep_file':
>> scripts/basic/fixdep.c:399: internal compiler error: segmentation fault
>> Please submit a full bug report,
>> with preprocessed source if appropriate.
>> See <URL:http://gcc.gnu.org/bugs.html> for instructions.
>> For Debian GNU/Linux specific bug reporting instructions,
>> see <URL:file:///usr/share/doc/gcc-4.1/README.Bugs>.
>> Preprocessed source stored into /tmp/ccyzmUDF.out file, please attach
>> this to your bugreport.
>> make[1]: ** [scripts/basic/fixdep] Error 1
>> make: ** [scripts_basic] Error 2
> 
> Is it repeatable or just a one-off?

I can't compile 2.6.22.5 because this error EVER appear.

> I'm using gcc 4.1.2 as well :
> 
> $ gcc --version
> gcc (GCC) 4.1.2

$ gcc --version
gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

I think that is missing some dependency, but build-essential package is 
installed.

Regards,
Renato
