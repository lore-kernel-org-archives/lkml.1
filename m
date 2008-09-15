Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYIOIbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYIOIbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYIOIbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:31:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:42688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYIOIbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:31:09 -0400
Message-ID: <48CE1CE8.502@kernel.org>
Date: Mon, 15 Sep 2008 01:29:28 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org> <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com> <48C948A6.3080404@kernel.org> <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com> <48C9AB5A.705@kernel.org> <20080912165947.GB5094@kroah.com>
In-Reply-To: <20080912165947.GB5094@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Sep 2008 08:30:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>>> On a related note, is there any plan to merge tp_smapi to mainline?
>>>> It seems you put a lot of work into it and I don't really see why it
>>>> should stay out of tree.
>>> The only issue I'm aware of is finding a reasonably-named maintainer.
>>> On the technical side, the reviews on my lkml submission of
>>> thinkpad_ec+hdaps seemed good and all technical comments are since
>>> addressed. The code has been stable, well-tested and packaged by major
>>> distros for years.
>> Cool, can you please post the patch to the lkml and cc Greg
>> Kroah-Hartman <gregkh@suse.de>, Andrew Morton
>> <akpm@linux-foundation.org> and me?
> 
> Sorry, but no, I can't accept this code as it is coming from a "known
> anonymous" person containing information that it is not known where it
> came from.
> 
> We went over this before a number of years ago, that's why this code
> isn't in mainline :(

Aieee... didn't know that and was wondering why the hell this wasn't
in mainline.  :-(

> In short, "Signed-off-by:" from people who are known to be anonymous is
> not allowed.

Shem Multinymous, I suppose nothing really has changd since the last
time?

Thanks.

-- 
tejun
