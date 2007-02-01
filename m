Return-Path: <linux-kernel-owner+w=401wt.eu-S1422691AbXBAImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422691AbXBAImT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422693AbXBAImT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:42:19 -0500
Received: from mx.laposte.net ([81.255.54.11]:38850 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422691AbXBAImS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:42:18 -0500
Message-ID: <54850.192.54.193.51.1170319212.squirrel@rousalka.dyndns.org>
In-Reply-To: <20070131234450.GB32078@kroah.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
    <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
    <20070131234450.GB32078@kroah.com>
Date: Thu, 1 Feb 2007 09:40:12 +0100 (CET)
Subject: Re: Free Linux Driver Development!
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "Greg KH" <greg@kroah.com>
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.fc6
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Le Jeu 1 février 2007 00:44, Greg KH a écrit :
> On Wed, Jan 31, 2007 at 06:00:15PM -0500, Theodore Tso wrote:

>> More specifically, Dave said that it "seemed rude" to just take the
>> driver and send updates, but maybe the best way of dealing with
>> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
>> kind of spec release, and just have someone in the community forcibly
>> take the code, fix it up, and then get it merged.  Maybe it's being
>> "rude", but so is not responding to requests to get it merged.
>
> No, I'm going by Linus's rule here, if a person doesn't want their code
> in the kernel tree, then I'm not going to forcefully put it there.
> That's just being rude.

Well, reengineering nvidia/ati DRM is rude to ati/nvidia, so was creating
tigon3, so was rewriting from scratch the GPL drivers some ATA vendors
published in the past, so was spurning the SATA/SAS stack adaptec
offered...

Does politeness extend to accepting some devices will never see in-tree
drivers because someone wrote a GPL out-of-tree driver first (and refuses
to push it)? People are more squeamish about using an out-of-tree driver
as reference instead of leaked specs or rev-engeneered windows drivers
(despite out-of-tree drivers being under the GPL ie with authorisation do
do whatever people want with the code).

If the answer is no, then there is a big pile of device documentation (in
the form of source code) waiting to be used.

-- 
Nicolas Mailhot

