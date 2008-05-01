Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbYEATgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbYEATgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763870AbYEATgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:36:13 -0400
Received: from mail.anarazel.de ([217.115.131.40]:60145 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761934AbYEATgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:36:12 -0400
From: Andres Freund <andres@anarazel.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION macro is used.
Date: Thu, 1 May 2008 21:36:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200805012005.42400.andres@anarazel.de> <20080501193107.GN29330@cs181133002.pp.htv.fi>
In-Reply-To: <20080501193107.GN29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805012136.03569.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008, Adrian Bunk wrote in "Re: [PATCH] v4l/dvb: Add 
linux/version.h include as KERNEL_VERSION macro is used.":
> The #include is already there a dozen lines below.
Hm. Strange.
It fixed a build error for me. Will retest and report back.

Andres
