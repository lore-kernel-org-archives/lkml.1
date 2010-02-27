Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968069Ab0B0J2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:28:09 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44883 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968038Ab0B0J2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:28:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fTzb5cLiAHM34RurvY1msXSkFelbkueeBaRU1PHlhmS9NabEA1hY0PVnMsS1XEMk4H
         2N8YPRFNQdOTHsTmw9EJYrSUqr9Q08YkIQt3YtQpxxeR+LFORWPGQPirpGpOsBzwhq6r
         2Ck0ksz9CCr+dsJezMvqb6pLU1OXZMAbjsF2U=
MIME-Version: 1.0
In-Reply-To: <1267130428-14175-1-git-send-email-chihau@gmail.com>
References: <1267130428-14175-1-git-send-email-chihau@gmail.com>
Date: Sat, 27 Feb 2010 11:28:04 +0200
Message-ID: <269694c01002270128g1367f0c4kb30a92acd95d6868@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: poc: Adding some KERN_ facility level
From: Ameya Palande <2ameya@gmail.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sgayda2@uiuc.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chihau,

On Thu, Feb 25, 2010 at 10:40 PM, Chihau Chau <chihau@gmail.com> wrote:
> From: Chihau Chau <chihau@gmail.com>
>
> This fixes some coding style issues like include KERN_ facility levels
> in some printk() and one trailing whitespace error.
>
> Signed-off-by: Chihau Chau <chihau@gmail.com>

While you are at it, instead of using printk(KERN_INFO ""); you can also use
pr_info();

Cheers,
Ameya.
