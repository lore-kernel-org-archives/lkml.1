Return-Path: <linux-kernel-owner+w=401wt.eu-S1750744AbZG0EAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750744AbZG0EAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 00:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbZG0EAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 00:00:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:64298 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG0EAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 00:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LMBfK3wZ34uHNP3REBDtSDWneA2l27KmFG6ga1iKUFGNkuqo5HJmT7i7yBcnEVFzxT
         kPqOQCqf4I3r2VjZb/LIQjalhX1BggUvxp70AeAac/WkBvo81fHrMzrIL1grWmHp08gj
         xj1ZrM6ymtTDJ5N9yz9mMa+UiPs8FB8IF0j0w=
MIME-Version: 1.0
In-Reply-To: <2375c9f90907262010s36980f88q28f10b6bc2b5263f@mail.gmail.com>
References: <2375c9f90907262010s36980f88q28f10b6bc2b5263f@mail.gmail.com>
Date: Mon, 27 Jul 2009 12:00:33 +0800
Message-ID: <3877989d0907262100la342487j52cf5e12e5efe520@mail.gmail.com>
Subject: Re: Boot panic in 2.6.31-rc4
From: Luming Yu <luming.yu@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SYSFS_DEPRECATED_V2 disabled by default?

On Mon, Jul 27, 2009 at 11:10 AM, Américo Wang<xiyou.wangcong@gmail.com> wrote:
> Hi,
>
> There is a regression in current Linus tree, I can't boot my RHEL5 any more.
