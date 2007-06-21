Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbXFUPGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbXFUPGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXFUPGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:06:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58501 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXFUPGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:06:42 -0400
Subject: Re: Request for Linux Kernel Mailing List archives
From: David Woodhouse <dwmw2@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: webguy@theaimsgroup.com, postmaster@lkml.org, postmaster@ussg.iu.edu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       postmaster@vger.kernel.org
In-Reply-To: <467949CC.9090405@zytor.com>
References: <467949CC.9090405@zytor.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 23:06:50 +0800
Message-Id: <1182438411.10524.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 08:37 -0700, H. Peter Anvin wrote: 
> I would like to make a request to LKML archives.  It would be a highly
> useful feature to have an archive site where one can algorithmically
> produce a URL from the Message-ID, so one can post a clickable URL from
> a delivered message without having to look it up every time.
> 
> For example, if a message had:
> 
> Message-ID: <4676C78D.8040208@zytor.com>
> 
> ... and I could just generate a URL:
> 
> http://linux-kernel.example.com/msgid/4676C78D.8040208@zytor.com
> 
> ... that would be highly convenient.
> 
> (Extra points if all the vger lists are available, not just LKML.)

Even more extra points if there's a mailto: link allowing people to
reply, which actually gets the threading information right. E.g.:

mailto:hpa@zytor.com,linux-kernel@vger.kernel.org?Subject=Re:%20Request %20for%20Linux%20Kernel%20Mailing%20List%20archives&In-Reply-To=4676C78D.8040208@zytor.com

-- 
dwmw2

