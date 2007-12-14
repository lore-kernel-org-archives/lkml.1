Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXLNB7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXLNB7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761383AbXLNB64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:58:56 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64352 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760785AbXLNB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:58:55 -0500
Date: Thu, 13 Dec 2007 17:57:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc5-mm1 -- drivers/video/logo/logo_linux_clut224.c:598:
 error: conflicting type qualifiers for =?UTF-8?Q?=E2=80=98logo=5Flinux=5F?=
 =?UTF-8?Q?clut224=E2=80=99?=
Message-Id: <20071213175736.674e3189.randy.dunlap@oracle.com>
In-Reply-To: <a44ae5cd0712131716n39d29ec4qa0dfd6ad64a50b0a@mail.gmail.com>
References: <a44ae5cd0712131716n39d29ec4qa0dfd6ad64a50b0a@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 20:16:13 -0500 Miles Lane wrote:

>   CC      drivers/video/logo/logo_linux_clut224.o
> drivers/video/logo/logo_linux_clut224.c:598: error: conflicting type
> qualifiers for 'logo_linux_clut224'
> include/linux/linux_logo.h:47: error: previous declaration of
> 'logo_linux_clut224' was here
> make[3]: *** [drivers/video/logo/logo_linux_clut224.o] Error 1

Hi Miles,

Did you try the patch that was posted today?

http://lkml.org/lkml/2007/12/13/439 & click on "Get diff 1"
on the left side.

---
~Randy
