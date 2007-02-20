Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbXBTGm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbXBTGm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964790AbXBTGm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:42:56 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33975 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXBTGmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:42:55 -0500
Message-ID: <45DA9878.2040108@drzeus.cx>
Date: Tue, 20 Feb 2007 07:43:04 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Racy NLS behaviour in FAT (and possible other fs)
References: <45D9C80A.2030905@drzeus.cx> <87tzxim6ic.fsf@duaron.myhome.or.jp>	<45D9D848.4010608@drzeus.cx> <87ps86m4to.fsf@duaron.myhome.or.jp>
In-Reply-To: <87ps86m4to.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Yes. But sorry, I don't have any plan and time to fix it now.
>   

I know the feeling. :)

I just wanted to know where things stand as I have little insight into
vfat development.

> If you are using "iocharset=utf8" now, "codepage=cp???,iocharset=xxx,utf8"
> might help a bit.
>   

These tests was with the "utf8" option.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

