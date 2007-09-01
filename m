Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXIAVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXIAVMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXIAVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:12:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbXIAVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:12:03 -0400
Message-ID: <46D9D587.9020605@zytor.com>
Date: Sat, 01 Sep 2007 22:11:35 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
References: <20070831201820.GF31970@nostromo.devel.redhat.com>
In-Reply-To: <20070831201820.GF31970@nostromo.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham wrote:
> As of now, the kernel defaults to non-unicode and XLATE for the keyboard.
> We've been changing this in Fedora, but that requires patching the defaults
> in the kernel.
> 
> The attached introduces CONFIG_VT_UNICODE, which sets the console in unicode
> mode by default on boot, including both the virtual terminal and the keyboard
> driver.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>

Wasn't there a patch floating around about this a couple of months ago, 
which also let you set the system-wide default via sysctl?

	-hpa
