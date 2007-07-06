Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXGFQIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXGFQIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXGFQIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:08:37 -0400
Received: from gw.goop.org ([64.81.55.164]:56329 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbXGFQIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:08:36 -0400
Message-ID: <468E6904.20003@goop.org>
Date: Fri, 06 Jul 2007 09:08:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: dead(?) i386-related CONFIG variables
References: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> ========== DEBUG_PAGE_TYPE ==========
> arch/i386/kernel/vmi.c:238:#ifdef CONFIG_DEBUG_PAGE_TYPE

That's a leftover from some of Zach's debug goo.  I don't think it was 
ever a real config option (at least, not outside VMWare).

    J
