Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbYESNmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbYESNmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765059AbYESNgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:36:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:34055 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763070AbYESNgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:36:03 -0400
Date: Mon, 19 May 2008 15:36:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 01/10] modpost: add support for hid
In-Reply-To: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0805191535071.6718@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Jiri Slaby wrote:

> Generate aliases for hid device modules to support autoloading.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Hi Jiri,

thanks for rebasing the series and fixing the comments raised during 
review.

However, I seem to miss the 10/10 patch from this series, and it doesn't 
seem to be even in my lkml/linux-input folder.

Thanks,

-- 
Jiri Kosina
SUSE Labs
