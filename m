Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYJ0Q33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYJ0Q33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYJ0Q3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:29:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:40968 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbYJ0Q3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:29:19 -0400
Date: Mon, 27 Oct 2008 17:29:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: usbhid, sync on deleted io_retry timer
In-Reply-To: <1225106176-5496-2-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810271729080.12928@jikos.suse.cz>
References: <1225106176-5496-1-git-send-email-jirislaby@gmail.com> <1225106176-5496-2-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Jiri Slaby wrote:

> When suspending, make sure that the timer is not running.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
