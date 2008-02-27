Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYB0QDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYB0QDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYB0QDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:03:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52468 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYB0QDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:03:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C589D1.1050508@s5r6.in-berlin.de>
Date: Wed, 27 Feb 2008 17:03:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, romanol@upcomillas.es
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
References: <1204056556.7745.22.camel@localhost> <1204056556.7745.22.camel@localhost> <47C4AEDC.80600@s5r6.in-berlin.de> <E1JULSV-0001qy-7N@faramir.fjphome.nl>
In-Reply-To: <E1JULSV-0001qy-7N@faramir.fjphome.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Stefan Richter wrote:
>> (On Gentoo, switching from X to console works with xf86-video-i810-2.1.1
>> but results in a black screen with xf86-video-i810-2.2.0.90.)
> 
> This sounds like that could be a bug I filed recently and which was solved
> in 2.2.1: http://bugs.freedesktop.org/show_bug.cgi?id=14481.

Indeed, 2.2.1 fixes this issue for me.
-- 
Stefan Richter
-=====-==--- --=- ==-==
http://arcgraph.de/sr/
