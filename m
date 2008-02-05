Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYBEI3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYBEI3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYBEI3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:29:11 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54488 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYBEI3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:29:10 -0500
Message-ID: <47A81E53.4010504@tiscali.nl>
Date: Tue, 05 Feb 2008 09:29:07 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ballabio_Dario@emc.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction
 == DMA_FROM_DEVICE'
References: <47A7937C.7040701@tiscali.nl> <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
In-Reply-To: <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ballabio_Dario@emc.com wrote:
>  Good to know that somebody still uses the Ultrastor 14f board :).....
> Yes, this typo was introduced by somebody doing massive editing to all
> scsi drivers long ago.
> Cheers,
> --db
Actually, I do not own a Ultrastor 14f board. I found this by searching for
if (test)
...
else if (exactly same test)
...
Thanks,
Roel
