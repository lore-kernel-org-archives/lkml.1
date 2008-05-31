Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYEaW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYEaW2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYEaW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:28:00 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:56877 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbYEaW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:28:00 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10632] [2.6.26-rc1] Output to console stops when booted without 'vga=791'
Date: Sun, 1 Jun 2008 00:27:52 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.PAG.qtZQIB@albercik>
In-Reply-To: <UJSav77TyUB.A.PAG.qtZQIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806010027.53285.elendil@planet.nl>
X-OriginalArrivalTime: 31 May 2008 22:27:53.0807 (UTC) FILETIME=[91629DF0:01C8C36D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10632
> Subject	: [2.6.26-rc1] Output to console stops when booted without 'vga=791'
> Submitter	: Frans Pop <elendil@planet.nl> 
> Date		: 2008-05-05 13:51 (27 days old)
> References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2080.html

This can be removed from the regressions list as the issue was already
present in earlier kernels. Sorry for not replying to earlier mails, but
I wanted to check that first and did not find the time to do so until now.

I'll try to find the origin of the issue and update bugzilla with that info.

Cheers,
FJP
