Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbYCTAGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbYCTAGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbYCSXF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:05:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39900 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162772AbYCSXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:05:53 -0400
Date: Thu, 20 Mar 2008 00:06:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
Message-ID: <20080319230624.GJ1811@elf.ucw.cz>
References: <20080319082115.GA14543@elf.ucw.cz> <47E19BA1.8010905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E19BA1.8010905@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-20 00:02:57, Jiri Slaby wrote:
> On 03/19/2008 09:21 AM, Pavel Machek wrote:
>> ...just leave ppp-over-cellphone-over-bluetooth running, and do
>> s2ram...
>>
>> Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
>> BIOS-provided physical RAM map:
>
> Pavel, does the "still" from $SUBJ mean, that 2.6.24 is affected too (if 
> this is the same what I hit)?

Hey, I did not do careful analysis. I believe it is the same problem
that affects 2.6.24, too, yes. But I actually believe it is much older
than that...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
