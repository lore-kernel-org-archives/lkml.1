Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134Ab0AAQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0AAQzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070Ab0AAQzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:55:15 -0500
Received: from samir.ibcsolutions.de ([78.47.90.66]:50308 "EHLO
	samir.ibcsolutions.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0AAQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:55:14 -0500
X-Greylist: delayed 1481 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jan 2010 11:55:14 EST
Message-ID: <4B3E6520.6030404@exys.org>
Date: Fri, 01 Jan 2010 22:12:00 +0100
From: Arvid Picciani <aep@exys.org>
Organization: Asgaard Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: David <david@unsolicited.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites
 in 	Firefox
References: <4B2FEE46.5030700@unsolicited.net> <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
In-Reply-To: <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2010 02:40 PM, Maciej Rutecki wrote:
> I can confirm this. Probably it's related only to wireless
> connections, wired seems be OK. My device is:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)

i sometimes get a dead system by calling dhclient. (i dont use ff)
Atheros AR9285.  happens only wth kms (intel 945G) enabled. Barely 
reproduceable. Works with wired connection. This device has no rs232 
connector, so i'm a bit out of ideas how to debug it.

-- 
Arvid
