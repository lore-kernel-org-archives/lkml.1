Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZKRXZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZKRXZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZKRXZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZKRXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:25:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
References: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: dhowells@redhat.com, linux-m68k <linux-m68k@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] TIF_NOTIFY_RESUME on m68k?
Date: Wed, 18 Nov 2009 23:25:35 +0000
Message-ID: <23325.1258586735@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> These commits broke CONFIG_KEYS=y on m68k, so technically the missing
> support is a regression compared to 2.6.31.

I couldn't work out how to do it.  I mentioned that it needed doing in the
logs in the hope that someone on the arch list would do it for the missing
arches.

David
