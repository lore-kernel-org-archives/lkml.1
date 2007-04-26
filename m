Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXDZNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXDZNjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXDZNjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:39:06 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:27625 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbXDZNjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:39:03 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Thu, 26 Apr 2007 07:39:20 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: lsorense@csclub.uwaterloo.ca
cc: "Jean Delvare" <khali@linux-fr.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070426133920.GA25456@cosmic.amd.com>
References: <20070414192807.60bdf84b@hyperion.delvare>
 <20070418174256.GB5577@csclub.uwaterloo.ca>
 <20070419085413.1520feef@hyperion.delvare>
 <20070419205942.GC5577@csclub.uwaterloo.ca>
 <20070420194933.0813a359@hyperion.delvare>
 <20070422154151.GJ5575@csclub.uwaterloo.ca>
 <20070423114254.71787844@hyperion.delvare>
 <20070423144710.GD1372@cosmic.amd.com>
 <20070426145634.3ac2b7a3@hyperion.delvare>
 <20070426132905.GP5575@csclub.uwaterloo.ca>
MIME-Version: 1.0
In-Reply-To: <20070426132905.GP5575@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Apr 2007 13:38:49.0240 (UTC)
 FILETIME=[38805980:01C78808]
X-WSS-ID: 6A2E74E31SK460923-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/07 09:29 -0400, lsorense@csclub.uwaterloo.ca wrote:
> 
> These return all 0x00
> 
> On the Geode LX800 where scx200_acb does work all 4 commands return all
> 0xff.

There is no ISA on the LX.

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


