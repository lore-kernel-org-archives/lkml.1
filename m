Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0BUINf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 03:13:35 -0500
Received: from mail-gx0-f225.google.com ([209.85.217.225]:59300 "EHLO
	mail-gx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0BUINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 03:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qhgGsOl6PuL3/T6c18WcmkfskDZ9+eXDk2pGrYpTC0n2GIWOPg113sfx/SlLhKv6QM
         LM2utFWYwQuqTITQN97BbllniJuYQCVRnJaeYc86Mi5kJtd0wy2zsdt6Qf2xOHjfzpm6
         +dvWn//MmP58VQgoESUDazZS6KyEUrYU3F2tY=
Date: Sun, 21 Feb 2010 00:13:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add driver for Roccat Kone gaming mouse
Message-ID: <20100221081327.GB18298@core.coreip.homeip.net>
References: <201002200911.53900.stefan_achatz@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002200911.53900.stefan_achatz@web.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sat, Feb 20, 2010 at 09:11:53AM +0100, Stefan Achatz wrote:
> This Patch adds support for Kone gaming mouse from Roccat.
> It provides access to profiles, settings, firmware, weight,
> actual settings etc. through sysfs files.

There is no documentation provided for all these new sysfs attributes
so it is really hard to judge their usefullness. For example why would
one care about weight?

Thanks.

-- 
Dmitry
