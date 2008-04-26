Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYDZIma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYDZIma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYDZImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:42:23 -0400
Received: from gw.goop.org ([64.81.55.164]:50100 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYDZImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:42:22 -0400
Message-ID: <4812EAE8.5000006@goop.org>
Date: Sat, 26 Apr 2008 01:42:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 0/3] xen: more portability patches
References: <12088476062604-git-send-email-yamahata@valinux.co.jp>
In-Reply-To: <12088476062604-git-send-email-yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> Hi Jeremy.
> Here are the 3 patches for ia64/xen support.
> The first one is just to move manage.c under drivers/xen.
> This is trivial.
>
> The second and third ones are for compilation fix on ia64.
> You may want to postpone those 2 patches to make your merge task
> easy as you said before.
>   

I've put these into my queue.  I'll submit them to Ingo when the merge 
window settles down.

    J
