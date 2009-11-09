Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKIWqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKIWqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZKIWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:46:14 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:19573 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZKIWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:46:14 -0500
Message-ID: <4AF89BA2.2050803@oracle.com>
Date: Mon, 09 Nov 2009 14:45:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Felipe Bica <felipebica@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: //include <stdarg.h>
References: <fd83a2470911091359m1bf817a0r8d0288121bcec377@mail.gmail.com>
In-Reply-To: <fd83a2470911091359m1bf817a0r8d0288121bcec377@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AF89BB7.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Bica wrote:
> Hi,
> 
> Sorry but... maybe somebody already had talk about stdarg,h, but at
> least I fell more social sending one email after build a linux kernel
> over nine thousand times this year. :)

Hi,
Is there a question or a problem??  ;)

Here is a comment from the past:

  *  include/linux/kernel.h (and many others) include <stdarg.h>
     BUT - since we are using -nostdinc, /usr/include/stdarg.h is not
     considered. And gcc's stdarg.h (which lives at
     /usr/lib/gcc/i586-suse-linux/4.1.2/include/stdarg.h in Linux land)
	[is used instead]


so what is your question?

~Randy
