Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502Ab0AVGLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab0AVGLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 01:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273Ab0AVGLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 01:11:52 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52282 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0AVGLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 01:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=vk3BcUuZXedjCcEkI/A2qCTfLYpV6veSLfuivGSeIY1BENFVqXTIU+jFRxsBf5OuKI
         jorYLgo6C1NlOSKyQQkhrz9D/sI+heYsvJ+RL3G3EGwO1kzzmOsMlt07AMCCldqYJW4o
         6t+JM+yWsMJkMnWaGviHaAKZoPTi3ohIQjmew=
MIME-Version: 1.0
In-Reply-To: <b713df2c1001210918n3b8f535dk5c4214384cc1a4e1@mail.gmail.com>
References: <b713df2c1001210918n3b8f535dk5c4214384cc1a4e1@mail.gmail.com>
Date: Fri, 22 Jan 2010 11:41:33 +0530
Message-ID: <b713df2c1001212211lc3feefbw2c86987638aaad65@mail.gmail.com>
Subject: VIA VT1708/A [Azalia HDAC] Microphone not Capturing sound bug fix
From: Siju George <sgeorge.ml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Microphones fitted to VIA VT1708/A does not capture sound even though
sound can be got from the speakers.

Can anybody please tell me if this bug is fixed in the kernel by now?
or at least if anybody is looking into it?

Starting Audacity on a system with the above hardware gives the error.

~$ audacity
Expression 'stream->capture.pcm' failed in
'src/hostapi/alsa/pa_linux_alsa.c', line: 3653

All Major distros are affected by it.

thanks for your time

--Siju
