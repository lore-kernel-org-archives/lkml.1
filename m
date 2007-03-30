Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXC3Vxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXC3Vxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXC3Vxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:53:48 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:59982 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbXC3Vxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:53:47 -0400
Date: Fri, 30 Mar 2007 23:52:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
In-Reply-To: <20070330144630.56d81d0d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0703302352450.31834@yvahk01.tjqt.qr>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
 <20070330144630.56d81d0d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 14:46, Andrew Morton wrote:
>
>ahem.
>
>On Fri, 30 Mar 2007 02:25:37 -0700
>"Ken Chen" <kenchen@google.com> wrote:
>
>> +static DEFINE_MUTEX(loop_devices_mutex);
>> ...
>> +	mutex_lock(&loop_device_mutex);
>
>which makes me suspect that you didn't send the patch which you meant to
>send, so I'll drop it.

/me smells plagiarism :)


Jan
-- 
