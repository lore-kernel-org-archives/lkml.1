Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZEALDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZEALDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZEALDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:03:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42829 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbZEALDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090501120131.642b1cae@lxorguk.ukuu.org.uk>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090501120131.642b1cae@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:02:56 +0200
Message-ID: <ac3eb2510905010402sd9202d4sab748f0eb0c05ee5@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 13:01, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> These are the ones that create a subdirectory in /dev/   None of the
>> others do.
>
> Yes they do - sound for example does.

Sound is already in there, in the posted version. And the few missing
are in my local tree.

Thanks,
Kay
