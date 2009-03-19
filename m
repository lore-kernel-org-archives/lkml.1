Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZCSPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZCSPAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZCSPAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:00:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:48539 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZCSPAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:00:06 -0400
Date: Thu, 19 Mar 2009 16:00:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: remove compat stuff
In-Reply-To: <1237364017-27361-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.2.00.0903191554380.14346@wotan.suse.de>
References: <1237364017-27361-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Jiri Slaby wrote:

> This removal was scheduled and there is no problem with later
> distros to adapt for the new bus, thanks to aliases.
> 
> module-init-tools map files are deprecated nowadays, so that
> the patch which introduced hid ones into the m-i-t won't be
> accepted and hence there is no reason for leaving compat stuff in.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jiri Kosina <jkosina@suse.cz>

This seems to be against some different codebase than what I currently 
have in my tree. I have manually fixed the patch and applied it to 
upstream-compat-remove branch, please check it whether it is OK by you.

Thanks,

-- 
Jiri Kosina
SUSE Labs
