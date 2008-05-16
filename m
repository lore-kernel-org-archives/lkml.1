Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYEPPdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYEPPdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYEPPdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:33:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYEPPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:33:38 -0400
Date: Fri, 16 May 2008 17:33:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Junjiro Okajima <hooanon05@yahoo.co.jp>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/67] aufs main header file
In-Reply-To: <1210948401415-git-send-email-hooanon05@yahoo.co.jp>
Message-ID: <alpine.LNX.1.10.0805161733150.15590@fbirervta.pbzchgretzou.qr>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
 <1210948401415-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 16:32, hooanon05@yahoo.co.jp wrote:
>+
>+#include <linux/version.h>
>+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
>+#error you got wrong version
>+#endif

Kill this.


