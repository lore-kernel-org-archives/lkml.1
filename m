Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYDIR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYDIR2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYDIR22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:28:28 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58116 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYDIR22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:28:28 -0400
Message-ID: <47FCFC93.9010209@s5r6.in-berlin.de>
Date: Wed, 09 Apr 2008 19:27:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com>
In-Reply-To: <47FCF6AF.8010703@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> Stefan Richter in http://lkml.org/lkml/2008/2/26/523 commented:
>> Jan Engelhardt, Benny Halevy, and Richard Knutsson wrote:
>> > -Tabs are 8 characters, and thus indentations are also 8 characters.
>> > -There are heretic movements that try to make indentations 4 (or even 2!)
>> > -characters deep, and that is akin to trying to define the value of PI to
>> > -be 3.
>> 
>> Don't do this
> 
> Again, I see no real reasons why not to besides being against Stefan's
> preferences.

BTW, my preference was about keeping the last traces of witty language
in this text, not about any particular whitespace language.

(Do you have an idea who wrote the sentences which that patch wanted to
delete, and more importantly, *why* he wrote it this way?  You
apparently don't yet, but maybe you think about it once more.  Thanks.)
-- 
Stefan Richter
-=====-==--- -=-- -=--=
http://arcgraph.de/sr/
