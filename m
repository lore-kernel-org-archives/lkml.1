Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZECFmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZECFmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZECFmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:42:12 -0400
Received: from mail.lang.hm ([64.81.33.126]:56247 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZECFmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:42:11 -0400
Date: Sat, 2 May 2009 22:40:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Willy Tarreau <w@1wt.eu>
cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
In-Reply-To: <20090503053557.GH570@1wt.eu>
Message-ID: <alpine.DEB.1.10.0905022239100.15782@asgard>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <20090501015902.ed8b56d3.akpm@linux-foundation.org> <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com> <20090503053557.GH570@1wt.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-201677387-1241329204=:15782"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-201677387-1241329204=:15782
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 3 May 2009, Willy Tarreau wrote:

> On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
>> On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
>>>
>>>> This is a repost of DRBD
>>>
>>> Is it being used anywhere for anything?  If so, where and what?
>>
>> One popular application is to run iSCSI and HA software on top of DRBD
>> in order to build a highly available iSCSI storage target.
>
> Confirmed, I have several customers who're doing exactly that.

I will also say that there are a lot of us out here who would have a use 
for DRDB in our HA setups, but have held off implementing it specificly 
because it's not yet in the upstream kernel.

David Lang
--0-201677387-1241329204=:15782--
