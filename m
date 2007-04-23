Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXDWOrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXDWOrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXDWOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:47:08 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:37150 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXDWOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:47:07 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Mon, 23 Apr 2007 08:47:10 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Jean Delvare" <khali@linux-fr.org>
cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070423144710.GD1372@cosmic.amd.com>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
 <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
 <20070414192807.60bdf84b@hyperion.delvare>
 <20070418174256.GB5577@csclub.uwaterloo.ca>
 <20070419085413.1520feef@hyperion.delvare>
 <20070419205942.GC5577@csclub.uwaterloo.ca>
 <20070420194933.0813a359@hyperion.delvare>
 <20070422154151.GJ5575@csclub.uwaterloo.ca>
 <20070423114254.71787844@hyperion.delvare>
MIME-Version: 1.0
In-Reply-To: <20070423114254.71787844@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Apr 2007 14:46:49.0051 (UTC)
 FILETIME=[3904DAB0:01C785B6]
X-WSS-ID: 6A3219531SK87141-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/07 11:42 +0200, Jean Delvare wrote:
> I seem to remember there has been a patch floating around to
> auto-detect the right ports back in June 2006, but it seems to have
> been lost somehow. Jordan, do you remember?

I don't remember that, and Google isn't helping, either.  Regardless,
randomly hitting ISA ports seems scary to me.  I know its a pain to use
the module params all the time, but thats really probably the cleanest way
to to it without carrying around a special patch for your system.

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


