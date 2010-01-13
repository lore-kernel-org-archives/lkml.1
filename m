Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260Ab0AMSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0AMSXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234Ab0AMSXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:23:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0AMSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:23:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B4E0F76.4040802@s5r6.in-berlin.de>
Date: Wed, 13 Jan 2010 19:22:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Julia Lawall <julia@diku.dk>,
       =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality
References: <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org> <201001131849.42328.bzolnier@gmail.com>
In-Reply-To: <201001131849.42328.bzolnier@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> BTW Personally I see nothing wrong with too verbose commit changelogs,
> too sparse changelogs are a much bigger annoyance..

Verbosity on its own does not ensure that the important bits happen to
be in the log though.

If somebody is deliberately verbose, please structure the message so
that the important bits can still be quickly spotted.  (Don't waste
people's time.)

However, a submission which can be adequately changelogged by one or two
lines, coupled with something like 30 lines of "and here is the script
that generated it for me" is just plain strange.  How is that fitting
for the final immutable history?  It's just noise.
-- 
Stefan Richter
-=====-==-=- ---= -==-=
http://arcgraph.de/sr/
