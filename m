Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYL3W27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYL3W27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYL3W2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:28:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYL3W2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:28:50 -0500
Message-ID: <495A9FC8.8000700@kernel.org>
Date: Tue, 30 Dec 2008 14:25:12 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, cpw@sgi.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: uv_bau.h fix dubious bitfield
References: <1230648229.10677.5.camel@jaswinder.satnam>
In-Reply-To: <1230648229.10677.5.camel@jaswinder.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied the following to tip:x86/cleanups:

Jaswinder Singh Rajput (3):
      x86: apic.c: xapic_icr_read and x2apic_icr_read should be static
      x86: uv_bau.h: fix dubious bitfield
      x86: xsave.c: restore_user_xstate should be static

Thanks!

	-hpa

