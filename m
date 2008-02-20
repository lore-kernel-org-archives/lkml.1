Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYBTN30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYBTN30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYBTN3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:29:18 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45051 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYBTN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:29:17 -0500
Message-ID: <47BC2B2C.90208@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 14:29:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Karl Dahlke <eklhad@comcast.net>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Valdis.Kletnieks@vt.edu
Subject: Re: adapter, what's in a name
References: <20080119181606.eklhad@comcast.net> <47BBF532.4030704@s5r6.in-berlin.de> <Pine.LNX.4.64.0802201116300.26109@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802201116300.26109@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 20 2008 10:38, Stefan Richter wrote:
>>Because of the high volume at this list, it is essential that
>>  - you keep everyone who posted in a tread in the Cc: list of your
>>    replies,
...
> Indeed, in PINE, mails with your address in Cc get preprended with a
> minus sign,

Also, one can have rules to automatically sort into different mail folders.

...
>>Aren't those drivers ones for
>>  - input devices,
>>  - display devices (in a more general sense than visual displays, i.e.
>>    also including audible and tactile displays)?
>>Besides, if you had for example an USB device of that type, the most
>>natural place for its sources would be somewhere beneath drivers/usb/.
> 
> Well actually, I think it would go into drivers/input/. It is not
> quite obvious.
> 
> Wireless USB -- drivers/net/wireless, not drivers/usb/
> Serial USB   -- drivers/usb/serial, not drivers/serial/usb/
> for example, but it seems to flow well anyway.

Right, I should have looked that up before posting.

Many drivers interact with more than one kernel subsystem, so the answer
to what put where is indeed not always obvious.
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
