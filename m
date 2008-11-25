Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYKYLxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYKYLxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYKYLxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:53:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:49373 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbYKYLxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:53:45 -0500
Date: Tue, 25 Nov 2008 12:53:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] USBHID: use GFP_KERNEL in hid_alloc_buffers
In-Reply-To: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0811251253141.19853@jikos.suse.cz>
References: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Jiri Slaby wrote:

> We might sleep, so no problem to use GFP_KERNEL.
> 
> While at it bring the function to coding style.

Applied, as well as the other three patches in the series. All queued for 
2.6.29.

Thanks!

-- 
Jiri Kosina
SUSE Labs
