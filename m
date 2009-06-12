Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZFLL46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZFLL46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZFLL4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:56:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54984 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754745AbZFLL4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:56:49 -0400
Date: Fri, 12 Jun 2009 12:58:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
Message-ID: <20090612125808.2b88deea@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0906120345s61c7216cp1925f05f829a1c3a@mail.gmail.com>
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org>
	<20090612113320.73e6f7f1@lxorguk.ukuu.org.uk>
	<8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
	<20090612113830.6c21dfc9@lxorguk.ukuu.org.uk>
	<8bd0f97a0906120345s61c7216cp1925f05f829a1c3a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mmm BOTHER is used to get arbitrary speeds right ?  i recall testing
> that on Blackfin already so i'm pretty sure that works ...

Blackfin isn't an offender on that one, but a few other people are ;)

Alan
