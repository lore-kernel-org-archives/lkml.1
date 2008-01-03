Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYACVrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYACVrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYACVrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:47:13 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:26377 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYACVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=G0Ky+ZIo5ynfNYonWFRt8G0ROokzgP8h2rQ5r51UBN9VPx++MwGjP1OBjrWKCJhedcjcAZPNjraY3oVidXZGEDuCRXLnrnTvtuNCe/v4WbPEWaQAbKJbEHQ2iZl7PMp6KnfOxPlyLxHjXB8YpaMA5LJyk9fg7sMf7dEIyhKdHRI=
Date: Thu, 3 Jan 2008 15:46:55 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080103154655.46feb4a1@vader.jdub.homelinux.org>
In-Reply-To: <20080103213255.GA21811@uranus.ravnborg.org>
References: <20080103213255.GA21811@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 22:32:55 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> kbuild.git contains at the moment 36 patches which is all for the upcoming merge window.
> It has been rebased to latest -linus git tree.
> See shortlog below.
> 
> Pending patches
> ===============
> kbuild:
[snip]

> - merge uboot mkimage (Josh Boyer)
>   await an update with a renamed script, maybe I already got it

I'm reworking right now actually.  Will post an updated version with
the binary renamed shortly.  I'll be sure to CC you when I do.

josh
