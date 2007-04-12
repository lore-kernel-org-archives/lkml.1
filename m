Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXDLAre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXDLAre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbXDLAre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:47:34 -0400
Received: from mx7.mail.ru ([194.67.23.27]:12684 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbXDLArd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:47:33 -0400
X-Greylist: delayed 4782 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 20:47:33 EDT
Date: Thu, 12 Apr 2007 04:44:30 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] [RFC] External power framework
Message-ID: <20070412004430.GA24758@zarina>
Reply-To: cbou@mail.ru
References: <20070411232446.GA20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232446.GA20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 050323f..c546de3 100644

I've forgot to pass -s flag to git-format-patch. :-/

Please count it for whole x/7 patch set:

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
