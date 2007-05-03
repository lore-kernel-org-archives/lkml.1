Return-Path: <linux-kernel-owner+w=401wt.eu-S376206AbXECQbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376206AbXECQbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376209AbXECQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:31:14 -0400
Received: from kirby.webscope.com ([204.141.84.54]:50796 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376206AbXECQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:31:13 -0400
Message-ID: <463A0E1B.2010509@linuxtv.org>
Date: Thu, 03 May 2007 12:30:19 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, xyzzy@speakeasy.org, mrechberger@gmail.com,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<4636E0E2.5020601@simon.arlott.org.uk>	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net> <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net> <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net> <463A0462.5070106@gmail.com> <20070503160514.184710@gmx.net> <463A0AB7.5030704@gmail.com>
In-Reply-To: <463A0AB7.5030704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham wrote:
> Uwe Bugla wrote:
>   
>> If you download the thing as tar.bz2 you get a zero file down.
>>     
>
> I think could be a bug in hgweb probably.
[snip]
> Let me see why hgweb gives a zero length archive
>   
Manu,

We reported this bug to the selenic guys quite a long time ago...   You
should inherit the fix if you upgrade mercurial on your server.


Regards,

Mike

