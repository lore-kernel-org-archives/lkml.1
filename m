Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYFSP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYFSP3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYFSP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:29:27 -0400
Received: from gw.goop.org ([64.81.55.164]:59973 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYFSP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:29:26 -0400
Message-ID: <485A7B2C.3070603@goop.org>
Date: Thu, 19 Jun 2008 08:28:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org> <485A465D.76E4.0078.0@novell.com> <20080619122718.GI7640@elte.hu>
In-Reply-To: <20080619122718.GI7640@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> you could do it as a second add-on patch as well - or as a respun patch. 
> Jeremy, is it now Acked-by you?

It seems sound but I think it needs another spin.

BTW, have you picked up the patches I sent out a couple of days ago?

    J
