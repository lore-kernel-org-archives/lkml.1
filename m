Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0BASD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:03:58 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:60429 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0BASD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:03:57 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: security ima: Kernel BUG in ima_file_free -- bisected to commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: zohar@us.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B666164.3090504@cn.fujitsu.com>
References: <4B666164.3090504@cn.fujitsu.com>
Date: Tue, 02 Feb 2010 03:03:33 +0900
Message-ID: <15772.1265047413@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Shi Weihua:
> Used the latest LTP to test 2.6.33-rc6, a Kernel BUG occured on my x86_64 (OS: Fedora 12).
> The message from dmesg is as following.
> The LTP case is testcases/kernel/syscalls/pipe/pipe06.c. For seeing code easily, I
> recreated a simple code to reproduce this BUG. please check the code in the attached.
> 
> I bisected a commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd,

The problem is already known and a patch is posted in last year.
http://marc.info/?l=linux-kernel&m=126206539702176&w=2


J. R. Okajima
