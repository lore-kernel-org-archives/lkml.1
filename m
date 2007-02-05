Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXBELVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXBELVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXBELVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:21:49 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:38515 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbXBELVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:21:48 -0500
Subject: Re: Where is CONFIG_SUSPEND_SMP hidden?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Christian Axelsson <smiler@lanil.mine.nu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45C7018B.2010802@lanil.mine.nu>
References: <45C7018B.2010802@lanil.mine.nu>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 22:21:46 +1100
Message-Id: <1170674506.6105.11.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-05 at 11:06 +0100, Christian Axelsson wrote:
> Hello!
> 
> I'm trying to enable swsusp on my intel core due laptop but I can't find 
>   the SUSPEND_SMP in menuconfig (or anywhere else except in .c-files).
> Where is the option hidden and what are the dependencies? I'm using 
> kernel 2.6.20, but failed to locate it in 2.6.19 aswell.

You want to enable HOTPLUG_CPU.

Regards,

Nigel

