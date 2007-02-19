Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbXBSEAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbXBSEAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 23:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXBSEAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 23:00:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:3252 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXBSEAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 23:00:39 -0500
Message-ID: <5640c7e00702182000p26f1ca8n15c1edcd8b3134a1@mail.gmail.com>
Date: Mon, 19 Feb 2007 17:00:36 +1300
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [BUG/WARN] Error initialising drivers in PCI
Cc: gregkh@suse.de, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <200702182158.13429.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com>
	 <200702182158.13429.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> Ian, you have an PATA controller so there is no need to use ata_piix.
> Just disabling ata_piix should workaround the issue.
>
OK. I have done this and the message goes away in boot logs. As you
say I don't need the old drivers anymore.

If you want me to test any fixes so both can coexist without throwing
a warning then just drop me a line.

Ian
-- 
Web: http://wand.net.nz/~iam4
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
