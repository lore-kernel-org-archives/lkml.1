Return-Path: <linux-kernel-owner+w=401wt.eu-S1764788AbXGVVS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788AbXGVVS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbXGVVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:18:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:55359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbXGVVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPKCzpjyBf6w+i1c4WakqfW6T50v2KdHpSizl/zUX5E8SiUC/Kav/Wwko0PDypxhZdjfxSQlr2KUvcHEkndU2eDuYfRqWcFPNuH2VNPnWlgnFWemC4Zygh9QroRaqMD05S3fK8q1nIWz+j5wSh0yuaouFOKIPYrT+XODv72bk9w=
Message-ID: <6101e8c40707221418q2ca52806o622c43fa7c35962b@mail.gmail.com>
Date: Sun, 22 Jul 2007 23:18:20 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707222300270.32367@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
	 <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
	 <Pine.LNX.4.64.0707222235130.32367@fbirervta.pbzchgretzou.qr>
	 <6101e8c40707221345gc24ed3o5ef3d379b85b400e@mail.gmail.com>
	 <Pine.LNX.4.64.0707222300270.32367@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the primary reason is add the Pentium D for help and the position
switch is secondary.

and the patch motivated to make by Tilman Schmidt's mail:
>More generally, what is the correct way of selecting the processor
>family option for a CPU whose name doesn't appear anywhere in the
>prompts or help texts in arch/i386/Kconfig.cpu? I guess there must
>be a way of deducing it from the content of /proc/cpuinfo, only I
>cannot figure out how.

when anybody not know where cpu own, that to be entitled to know, that
the cpu-s is sorted by time-line or likely I know this?
