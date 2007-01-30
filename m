Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbXA3Ngk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbXA3Ngk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965376AbXA3Ngk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:36:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45598 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965373AbXA3Ngk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:36:40 -0500
Message-ID: <45BF49DC.3060206@pobox.com>
Date: Tue, 30 Jan 2007 08:36:28 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_platform: fallout from set_mode() change
References: <E1HBsxd-0002NU-Uz@ZenIV.linux.org.uk>
In-Reply-To: <E1HBsxd-0002NU-Uz@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

This is already in the queue via Andrew, who caught the same problem.

Sometimes it seems like you and Andrew are the only people to build on 
non-x86 these days...

	Jeff



