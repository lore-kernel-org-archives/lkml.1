Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460Ab0AQEyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0AQEyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 23:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355Ab0AQEyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 23:54:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34962 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0AQEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 23:54:43 -0500
MIME-Version: 1.0
Date: Sat, 16 Jan 2010 23:54:37 -0500
X-Google-Sender-Auth: 6055b70c91a05377
Message-ID: <d4fb20ca1001162054y731bb232w4e1e999fa79372ba@mail.gmail.com>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
From: Gregory Moyer <raven2k@syphr.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I contacted LiteON technical support in the meantime, but they are no
>
> help. They said they tested with one Linux system and it worked.
>
> I will probably buy one of the above VIA cards and use it for this drive.
>
> Thanks for helping!


I too am having the same problem with the iHOS104. I filed a bug
report against Ubuntu Karmic
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/344093). At
least one other person reporting on that same bug report has confirmed
the issue. We are both seeing the problem with nVidia chipsets using
the sata_nv driver. There is a lot of information in the report, so
I'll skip re-posting it all here. However, as the previous poster
mentioned, after contacting LiteOn support, I was told the drive works
in Mandriva 2007.0. I tried it and sure enough, it does. The other
poster in the linked report confirmed this as well, stating that for
that distribution, the kernel was at 2.6.17 and the sata_nv driver was
at 0.8. I have tried several distributions/kernels, including 2.6.32.
I have also tried a myriad of kernel and BIOS options, including all
of the ones mentioned so far in this thread. If I can help in any way
to get this resolved, please let me know. Thanks for taking the time
to look into it.
