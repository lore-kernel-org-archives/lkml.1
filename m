Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbZJOLM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbZJOLM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761460AbZJOLM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:12:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:44036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766AbZJOLM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:12:57 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Massimo Cetra" <mcetra@navynet.it>
Date: Thu, 15 Oct 2009 22:12:05 +1100
Message-ID: <9a9a41fd6c04a891d8b3c4279903edd9.squirrel@neil.brown.name>
In-Reply-To: <4AD6FF9B.6060109@navynet.it>
References: <4AD5DC1D.9070002@navynet.it> <4AD5DC1D.9070002@navynet.it>1 2
    <4AD62690.9080408@navynet.it> <200910142232.14837.elendil@planet.nl>
    <4AD6FF9B.6060109@navynet.it>
Subject: Re: Bug on barriers for virtio_blk device - end_request: I/O error,
  dev vda, sector 0
Cc: "Frans Pop" <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Mark McLoughlin" <markmc@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Mikulas Patocka" <mpatocka@redhat.com>,
       "Alasdair G Kergon" <agk@redhat.com>,
       "virtualization" <virtualization@lists.linux-foundation.org>,
       "dm-devel" <dm-devel@redhat.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, October 15, 2009 9:55 pm, Massimo Cetra wrote:
> Frans Pop ha scritto:
>> Added CCs for the author of and people CCed on the patch.
>>
>> The patch has been submitted twice (6 Aug, 3 Sept), the first time there
>> was one concern voiced which seems to have been addressed in replies.
>> The
>> second time there were no reactions.
>>
>> The patch seems to work for Massimo...
>
> [CUT]
>
>>> No one listening here ?
>>
>> It helps if you CC the people who maintain the relevant code.
>
> Thanks, Frans.
>
> By the way, where can i find a list of the mantainers of the various areas
> ?
> I found it some years ago, but it seems i can't find it anymore.
> It's probably under my eyes... but i'm blind.

See http://lwn.net/Articles/356890/
     "Ask a kernel developer, part 2"
(you'll have to wait a week if you aren't a subscriber).

(or try ./scripts/get_maintainer.pl)

NeilBrown

>
> Thanks again
> Massimo
>

