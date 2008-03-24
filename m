Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYCXUvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYCXUvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYCXUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:50:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYCXUuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:50:55 -0400
Message-ID: <47E8142D.4040301@garzik.org>
Date: Mon, 24 Mar 2008 16:50:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Burning CDs as user produces coasters (Plextor drive)
References: <9d2cd630803241039m79c47754v6562404133a61274@mail.gmail.com>
In-Reply-To: <9d2cd630803241039m79c47754v6562404133a61274@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregor Jasny wrote:
> Hi,
> 
> since some time burning ISO CD images as user fails.
> Wodim stops during OPC and the kernel prints some messages:
> 
> scsi: unknown opcode 0xe9
> scsi: unknown opcode 0xed
> scsi: unknown opcode 0xf5
> scsi: unknown opcode 0xeb
> 
> If I burn as root, everything works fine. The used CD writer is a
> "PLEXTOR  DVDR   PX-712A   1.09". I've seen in the wodim/cdrecord
> sources that plextor drives are handled different from other drives.
> 
> Do you know what the above listed commands are for?
> Maybe they could be included in blk_verify_command?
> If your'e not sure about the dangerousness maybe as a config option?

What drivers and kernel versions work (and which fail)?

	Jeff



