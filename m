Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYBYTHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYBYTHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYBYTHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:07:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYBYTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:07:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C311DE.8090802@s5r6.in-berlin.de>
Date: Mon, 25 Feb 2008 20:07:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de> <47BC6EEC.4020000@s5r6.in-berlin.de> <47C04F99.6030704@m3y3r.de> <47C05A51.7000209@s5r6.in-berlin.de> <47C3079E.9080309@m3y3r.de> <47C30FBE.6020903@s5r6.in-berlin.de>
In-Reply-To: <47C30FBE.6020903@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thomas Meyer wrote:
>> So i did a "make clean" and a "make" (not a make -j3 as i use to do) 
>> and recompiled 2.6.25-rc3 and now it works again. Case closed under 
>> strange error.
>> 2.6.24 works with the same config, i.e. both drivers are build as 
>> modules.

BTW, of course "make -j..." is supposed to work.  I use it all the time 
and also did runtime tests of -rc2 and -rc3 built in that way, FWIW.
-- 
Stefan Richter
-=====-==--- --=- ==--=
http://arcgraph.de/sr/
