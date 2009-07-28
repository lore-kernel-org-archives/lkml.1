Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZG1KoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZG1KoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZG1KoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:44:17 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:52768 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbZG1KoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:44:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire vblank..."
Date: Tue, 28 Jul 2009 12:44:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, rol@witbe.net
References: <20090728091622.50e9933b@tux.DEF.witbe.net>
In-reply-To: <20090728091622.50e9933b@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281244.13467.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jul 2009 10:44:14.0505 (UTC) FILETIME=[5974A190:01CA0F70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I sent a mail long ago about this message :
> tux kernel: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22 showing up more than 10 times per second, but was told
> that I had some old userspace apps running... As I was using an old
> FC8, I forgot about it.

The message does not only show with old applications, it also shows:
- every time I suspend my notebook
- every time I start a second X session to log in as a different user

I agree that the message is very annoying and would be glad to be rid of 
it, especially as the only comment from the maintainers so far has been 
to just ignore it.
IMHO, If it is "ignoreable", then it is also "suppressable".

Thanks for your patch. I think I'll add it to my local branch too.

Cheers,
FJP
