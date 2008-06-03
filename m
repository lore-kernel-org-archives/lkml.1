Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYFCUwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYFCUwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYFCUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:51:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42360
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbYFCUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:51:52 -0400
Date: Tue, 03 Jun 2008 13:13:43 -0700 (PDT)
Message-Id: <20080603.131343.86564905.davem@davemloft.net>
To: raimoschmidt@gmail.com
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <a5f334790806031259nc872dcekd00315d3e5bea048@mail.gmail.com>
References: <20080603.062253.17158135.davem@davemloft.net>
	<18501.39659.952880.727014@alkaid.it.uu.se>
	<a5f334790806031259nc872dcekd00315d3e5bea048@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Raimo Schmidt" <raimoschmidt@gmail.com>
Date: Tue, 3 Jun 2008 23:59:49 +0400

> Hello. I've the same problem runnin' X.org 6 using kernel 2.6.25.4 on PC.
> After few seconds of black screen it writes that X.org died

The patch discussed here is sparc64 specific so won't in any way
help your case on a PC, sorry.
