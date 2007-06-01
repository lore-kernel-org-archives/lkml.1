Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbXFAQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbXFAQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXFAQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:41:27 -0400
Received: from relay4.usu.ru ([194.226.235.39]:33707 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbXFAQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:41:26 -0400
Message-ID: <46604C31.2070009@ums.usu.ru>
Date: Fri, 01 Jun 2007 22:41:21 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: lkml@dervishd.net
Subject: Re: Kernel utf-8 handling
References: <20070601142058.GA2587@DervishD> <46604928.4050002@ums.usu.ru>
In-Reply-To: <46604928.4050002@ums.usu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> The switch is possible. You could try the latest development LFS LiveCD 
> (http://ums.usu.ru/~patrakov/test/lfslivecd-x86-6.3-pre2-r1897.iso) and 
> see if it works for you (be sure to CC: me if you post any feedback).

I was wrong. The problem is that input works, output works, but 
copying-and-pasting with gpm doesn't work (the stable version of the CD, 
http://ums.usu.ru/~patrakov/x86/lfslivecd-x86-6.2-5.iso, contains a 
rejected-upstream kernel patch that hides the issue). This means that for 
all serious Unicode work, you must use X.

-- 
Alexander E. Patrakov
