Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXJMSuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXJMSuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbXJMSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:50:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33526 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbXJMSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:50:47 -0400
Message-ID: <47111380.5010106@garzik.org>
Date: Sat, 13 Oct 2007 14:50:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from elsa setup split
References: <20071013184242.GM8181@ftp.linux.org.uk>
In-Reply-To: <20071013184242.GM8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> ... and yes, caller wants it to return int.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

ACK (I was just about to send same)


