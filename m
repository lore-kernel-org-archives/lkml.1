Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXGEWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXGEWXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbXGEWXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:23:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:33856 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXGEWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YkBKmeNlehETlmbvviN/kBnXHDmdsNXdsnCY6ZhSuBdQvR5WoPErLB1dzt5FoLW+mfW4+sqHhphG4FekdAr947tp2U7htxL6ROVfjy0Z+0bZMruTwW5ImM206OGbGueWUyHG9eL6KF1PugiAt4aDPpWLl4l4+u8oVGHmgLYRO9E=
Message-ID: <92a12cdb0707051523s70eb1f96u8e863057fcaf91fb@mail.gmail.com>
Date: Thu, 5 Jul 2007 23:23:32 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: alsa-devel@alsa-project.org, "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] ALSA AICA sound on SEGA Dreamcast - fix behaviour in poor resource conditions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <92a12cdb0707051507r7ab1516blb7ea755d89c25efa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707051507r7ab1516blb7ea755d89c25efa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> Patch against code in alsa-kernel - tested with patched up 2.6.21-rc7
> and working well
>

Apologies - obviously I mean 2.6.22-rc7 patched with the aica driver
now in alsa-kernel
