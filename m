Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYHIWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYHIWRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYHIWRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:17:25 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44176 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYHIWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:17:25 -0400
Message-ID: <489E1769.50607@keyaccess.nl>
Date: Sun, 10 Aug 2008 00:17:13 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not auto-grab port 0x250
References: <489DE890.1090103@keyaccess.nl>	<20080809214657.3b5318d1@lxorguk.ukuu.org.uk>	<489E13C0.4010807@keyaccess.nl> <20080809225502.27b38a9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080809225502.27b38a9d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-08-08 23:55, Alan Cox wrote:

> It never breaks anything for anyone as a module, only compiled in.

Exactly, such as during a randconfig which is the issue. If I change 
things to not autograb when builtin, autograb when modular, would you 
still object?

Rene.
