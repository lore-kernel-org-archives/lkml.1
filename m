Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYAHRGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYAHRGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbYAHRGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:06:42 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60828 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYAHRGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:06:41 -0500
Message-ID: <4783AD65.5040005@s5r6.in-berlin.de>
Date: Tue, 08 Jan 2008 18:05:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Michal Simek <simekm2@fel.cvut.cz>,
       linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz>	 <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>	 <84144f020801080049r487690ffv9f49c68160b205d2@mail.gmail.com> <386072610801080100w30b7c6dar773e47de1472a030@mail.gmail.com>
In-Reply-To: <386072610801080100w30b7c6dar773e47de1472a030@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> On Jan 8, 2008 4:49 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> On Jan 8, 2008 10:28 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
>> > 1. Push patches to LKML when merge window open (2 weeks after a stable
>> > kernel version release, for example 2 weeks after 2.6.24 released)
>>
>> You shouldn't wait for the merge window to open to send patches for
>> review for the first time; otherwise you'll just miss the opportunity
>> to merge ;-).
>>
> 
> Really? I was told before to send out big patch to LKML for the merge window.
> If not, it's good news for Michal and MicroBlaze guys.

There aren't any fixed windows for development, review, testing, and so
on.  There is only Linus' merge window for the merge process of the
patches that have been reviewed, tested, and pre-integrated.

Of course people like akpm and the maintainers of the larger subsystems
necessarily align their own work with Linus', therefore there may be
periods around merge windows during which relevant people won't
integrate larger submissions.  But that does not mean you could not post
them.
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
