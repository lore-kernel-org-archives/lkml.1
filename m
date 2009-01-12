Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZALSas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZALSas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZALSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:30:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:39517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZALSaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BSo245Ilt3M5M2ZOW2a5EmGTNiolwUTjtC+12lXnfUMyCc64kEIJ+jL9MKNZ7EmrC5
         1JIt6PwJ/wYR27suMPhyTNrLygOm678Fbg5Wm8/3z6nwEwq6sX2v5C+nQxmPA/JddzXQ
         87/n6UebE88DZz28N9uVuPvaSSJPUFg1iMn3M=
Date: Mon, 12 Jan 2009 19:30:32 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Jan Dittmer" <jdi@l4x.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Message-ID: <20090112193032.174e394c@diego-desktop>
In-Reply-To: <200901120956.31728.jbarnes@virtuousgeek.org>
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	<21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
	<621d098f0901120037y4e17b4bn8d52a8ecdbc3fcff@mail.gmail.com>
	<200901120956.31728.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 12 Jan 2009 09:56:30 -0800, Jesse Barnes <jbarnes@virtuousgeek.org> escribió:

> I do much of my testing on GM965, so you should be able to get it to work with 
> the latest bits:
>   - libdrm from git master of mesa/drm
>   - mesa from git master of mesa/mesa
>   - xf86-video-intel from git master
>   - drm-intel-next from anholt's kernel tree
>     (git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel)


Users ARE going to try modesetting when 2.6.29 is released (there's
people already trying to test it in -rcs ;), so I think it's better
to put as much detailed documentation as possible somewhere.

I've created http://xorg.freedesktop.org/wiki/ModeSettingHowTo
with the quoted instructions for that.
