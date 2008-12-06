Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYLFOzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYLFOzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYLFOyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:54:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:56842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYLFOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=mxEOiG/0CyV3GDU519CiiF4fQMRNCJlN3UxB3BfTtRH9r30WYMo1OzwaG3urCibYbM
         VIHqIBoh7WzRouMNFfDLODb3nxcBwEvRzV6Ie6RRvjsBEtysG9Ks5VPpXfQCV92oLd0M
         Kvez/xWPfHSAYK8354WaZy1o8+jlPi39eQX1Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 00/06] ide-atapi: more leftovers
Date: Sat, 6 Dec 2008 15:51:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812061551.20772.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here are the reworked patches of the first batch of ide-cd to generic
> conversion. They've been lightly tested with ide-floppy only since the
> ide-cd is still needs rewiring after all is moved to ide-atapi.

Thanks, I applied everything except patch #5 (which needs fixup because
it goes too far into the future ;-).
