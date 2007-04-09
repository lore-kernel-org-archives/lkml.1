Return-Path: <linux-kernel-owner+w=401wt.eu-S965491AbXDIULg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbXDIULg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXDIULg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:11:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57565 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965491AbXDIULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:11:35 -0400
Message-ID: <461A9DF5.1050901@garzik.org>
Date: Mon, 09 Apr 2007 16:11:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com>	<200704091137.01336.gene.heskett@gmail.com>	<17946.29660.368403.553290@smtp.charter.net>	<200704091549.51805.gene.heskett@gmail.com> <17946.40257.794493.294518@smtp.charter.net>
In-Reply-To: <17946.40257.794493.294518@smtp.charter.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> The only sure strategy is to do your dumps in single user mode, with
> only one process touching the filesystem during the backup window.
> This obviously won't fly in a 24x7 environment, so people take their
> calculated chances and run backups with the system live.  

That's what snapshots are for.

No need for single user mode or taking chances.

A snapshot gives you a consistent filesystem that you can dump or tar.

	Jeff


