Return-Path: <linux-kernel-owner+w=401wt.eu-S934235AbZJIU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235AbZJIU5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934119AbZJIU5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:57:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929AbZJIU5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:57:16 -0400
Message-ID: <4ACFA36F.6000105@zytor.com>
Date: Fri, 09 Oct 2009 13:56:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF9184.9040104@msgid.tls.msk.ru> <200910092202.51208.a.miskiewicz@gmail.com>
In-Reply-To: <200910092202.51208.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 01:02 PM, Arkadiusz Miskiewicz wrote:
> 
> I had exactly this problem few weeks ago with pdksh as /bin/sh (and 
> bugreported to author of that change). As I workaround I used /bin/echo but 
> using printf is more sane/portable.
> 

Yes, using printf is the right thing to do.

A patch would be appreciated.

	-hpa
