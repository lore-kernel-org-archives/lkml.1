Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbXEKUWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbXEKUWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbXEKUV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:21:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbXEKUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:21:57 -0400
Message-ID: <4644CFB0.10603@zytor.com>
Date: Fri, 11 May 2007 13:18:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
References: <20070406154628.GG12005@jukie.net> <m1zm4rd676.fsf@ebiederm.dsl.xmission.com> <20070429094135.GA10948@suse.de> <20070511182329.GJ4052@ucw.cz>
In-Reply-To: <20070511182329.GJ4052@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> I do not think OLPC is using linuxBIOS these days. What they have
> certainly looks like Sun's ROM monitor.
> 

That would be OpenFirmware, then.

	-hpa
