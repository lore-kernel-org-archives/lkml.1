Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbYBYS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbYBYS7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYBYS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:59:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40421 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbYBYS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:59:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C30FBE.6020903@s5r6.in-berlin.de>
Date: Mon, 25 Feb 2008 19:58:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de> <47BC6EEC.4020000@s5r6.in-berlin.de> <47C04F99.6030704@m3y3r.de> <47C05A51.7000209@s5r6.in-berlin.de> <47C3079E.9080309@m3y3r.de>
In-Reply-To: <47C3079E.9080309@m3y3r.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> So i did a "make clean" and a "make" (not a make 
> -j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again. 
> Case closed under strange error.
> 2.6.24 works with the same config, i.e. both drivers are build as 
> modules.

What a relief. :-) Thanks for retesting.
-- 
Stefan Richter
-=====-==--- --=- ==--=
http://arcgraph.de/sr/
