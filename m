Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYDUVDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYDUVDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYDUVD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:03:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:61489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYDUVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=mwFsezCeh5rz2CXox/W2ZBuSKLjxS+7y3oSfRFIms3b/+ZvIC/wvHXn+ly4KBr0KvDz/LwsL5nGf5UrcSWxn3RGlDAUk9m2OgVrYDlmD/AOtE9H8hpygBdfi2Gg64L7fOU8WKYtkNQbZIc2QEI+eGNrGkEpivFt/TvUPuuC5USk=
Date: Mon, 21 Apr 2008 23:01:46 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-mm1 -- WARNING: at fs/sysfs/dir.c:427
	sysfs_add_one+0x33/0x9a()
Message-ID: <20080421210146.GK7134@slug>
References: <a44ae5cd0804181124s772fa61bp22035c2b758471b1@mail.gmail.com> <a44ae5cd0804211156n40e2a71cw25c3114db2f58d17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0804211156n40e2a71cw25c3114db2f58d17@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 02:56:52PM -0400, Miles Lane wrote:
> Is anyone interesting in following up on this?
> 
Doesn't this
http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-04/msg06990.html
fixes it?

Regards,
Frederik
