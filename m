Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbYBLJqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbYBLJqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbYBLJqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:46:34 -0500
Received: from smtp.nokia.com ([192.100.105.134]:64661 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYBLJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:46:33 -0500
Message-ID: <47B16A40.6080605@yandex.ru>
Date: Tue, 12 Feb 2008 11:43:28 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBI: add mtd_num sysfs attribute
References: <200802071907.m17J7eYA022058@hera.kernel.org> <20080208054743.GA13097@kroah.com> <47AC1205.5070907@nokia.com> <20080208163108.GE16477@kroah.com>
In-Reply-To: <20080208163108.GE16477@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Feb 2008 09:46:06.0827 (UTC) FILETIME=[16E033B0:01C86D5C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> I assume you'll put it into your tree and take the further care of it, 
>> right?
> 
> No, it needs to go through the same path that your other UBI patches
> went through.  Can you do that?

Ok, added your ack and sent a git-pull request to Linus
(Subject: [GIT-PULL] UBI updates)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
