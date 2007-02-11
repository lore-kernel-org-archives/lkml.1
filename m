Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXBKSET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXBKSET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXBKSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:04:19 -0500
Received: from sardaukar.technologeek.org ([213.41.134.240]:55208 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbXBKSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:04:19 -0500
From: Julien BLACHE <jb@jblache.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix USB vendor and product IDs endianness for USB HID devices
References: <87k5yp90v1.fsf@sonic.technologeek.org>
	<Pine.LNX.4.64.0702111822190.22290@jikos.suse.cz>
Date: Sun, 11 Feb 2007 19:04:24 +0100
In-Reply-To: <Pine.LNX.4.64.0702111822190.22290@jikos.suse.cz> (Jiri Kosina's
	message of "Sun, 11 Feb 2007 18:24:50 +0100 (CET)")
Message-ID: <87abzk1sgn.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> wrote:

Hi,

> this is obviously a bug, thanks for a fix, I queued it for upstream.

Thanks.

> Two nitpicks:
>
> - could you please submitpatches in standard conventions, so that they 
>   could be applied directly using patch -p1 against toplevel of the kernel 
>   tree (your patch was just against hid-core.c, but without any path)

Gah, I did that again. Sorry.

> - please inline patches in message and do not attach them, if possible

Same here, got fooled again into doing an inline MIME part instead of
inlining the patch for real.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
