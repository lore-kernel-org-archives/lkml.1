Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZFVJCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZFVJCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZFVJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:01:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZFVJBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:01:50 -0400
Date: Mon, 22 Jun 2009 11:01:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: hiddev, fix lock imbalance
In-Reply-To: <1245446651-1652-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.2.00.0906221101290.7457@wotan.suse.de>
References: <1245446651-1652-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Jiri Slaby wrote:

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/hid/usbhid/hiddev.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Applied, thanks a lot for spotting that.

-- 
Jiri Kosina
SUSE Labs
