Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0BLUjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:39:23 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:60148 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab0BLUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:39:22 -0500
Message-ID: <4B75BC78.4030601@mandriva.org>
Date: Fri, 12 Feb 2010 22:39:20 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: Paul Rolland <rol@witbe.net>
CC: Thomas Backlund <tmb@mandriva.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc8
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>	<4B75B5D8.5080602@mandriva.org> <20100212212632.53cbdc46@tux.DEF.witbe.net>
In-Reply-To: <20100212212632.53cbdc46@tux.DEF.witbe.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.02.2010 22:26, Paul Rolland skrev:
> Hello,
>
> On Fri, 12 Feb 2010 22:11:04 +0200
> Thomas Backlund<tmb@mandriva.org>  wrote:
>
>> 12.02.2010 21:49, Linus Torvalds skrev:
>>>
>>> I think this is going to be the last -rc of the series, so please do
>>> test it out. A number of regressions should be fixed, and while the
>>> regression list doesn't make me _happy_, we didn't have the kind of
>>> nasty things that went on before -rc7 and made me worried.
>>>
>> Has the mirroring broken down ?
>
> -ECANTDOWNLOAD
>
> +1 from France using ftp.kernel.org :
> ftp>  dir linux-2.6.33-rc7*
> 227 Entering Passive Mode (199,6,1,164,158,19).
> 150 Here comes the directory listing.
> -rw-rw-r--    1 536      536      66191954 Feb 06 22:27 linux-2.6.33-rc7.tar.bz2
> -rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.bz2.sign
> -rw-rw-r--    1 536      536      84523618 Feb 06 22:27 linux-2.6.33-rc7.tar.gz
> -rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.gz.sign
> -rw-rw-r--    1 536      536           248 Feb 06 22:27 linux-2.6.33-rc7.tar.sign
> 226 Directory send OK.
> ftp>  dir linux-2.6.33-rc8*
> 227 Entering Passive Mode (199,6,1,164,203,16).
> 150 Here comes the directory listing.
> 226 Directory send OK.
> ftp>  quit
>
> and www.kernel.org doesn't contain reference to -rc8 yet.
>


I _know_ that, that's why I ask !

Point is that I see -rc8 on git changelog on gmane,
but not on git.kernel.org, git.us.kernel.org, or ...

This has never happend before...
I usually see the -rcX tag on git.kernel.org _before_ Linus announces 
this...

So I ask if the mirroring has broken for some reason...
For example the tests with XZ migration ...

--
Thomas
