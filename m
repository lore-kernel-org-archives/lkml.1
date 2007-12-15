Return-Path: <linux-kernel-owner+w=401wt.eu-S1764663AbXLOClw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764663AbXLOClw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXLOCld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:41:33 -0500
Received: from rtr.ca ([76.10.145.34]:3840 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbXLOClc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:41:32 -0500
Message-ID: <47633EDA.6020004@rtr.ca>
Date: Fri, 14 Dec 2007 21:41:30 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_K=FChn?= <breiteseite1337@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [x86_64] remove unused variable from drivers/ata/ahci.c
References: <47631BC0.5090500@googlemail.com>
In-Reply-To: <47631BC0.5090500@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kühn wrote:
> Hi,
> 
> my first kernel patch, yay. :-)
> 
> On the file drivers/ata/ahci.c in line 1433 is declared a variable that
> is never used in the function. I removed it.
> 
> Patch is in attachments (based on 2.6.23.10).

...

You'll need to do:

(1) repost it, but this time to linux-ide@vger.kernel.org,
(2) place the patch INLINE, where it's easier to comment/correct as needed,
(3) include a Signed-off-by line,
(4) read / follow much of the Documentation/SubmittingPatches file.

*Then* you can try for fame and glory!

:)
