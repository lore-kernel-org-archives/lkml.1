Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066Ab0A0GoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0A0GoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974Ab0A0GoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:44:17 -0500
Received: from www84.your-server.de ([213.133.104.84]:57601 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab0A0GoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:44:17 -0500
Subject: Re: [PATCH 1/4] kernel/kfifo.c: fix "interger as NULL pointer" 
 warning.
From: Stefani Seibold <stefani@seibold.net>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <a4c8a6d01001261739x2ea25aeev3d5fe596169c7d74@mail.gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
	 <1264353324.5592.1.camel@wall-e>
	 <a4c8a6d01001261739x2ea25aeev3d5fe596169c7d74@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Jan 2010 07:44:21 +0100
Message-ID: <1264574661.18186.0.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 26.01.2010, 23:39 -0200 schrieb Thiago Farina:
> Hi Stefani,
> 
> On Sun, Jan 24, 2010 at 3:15 PM, Stefani Seibold <stefani@seibold.net> wrote:
> > Am Sonntag, den 24.01.2010, 11:03 -0500 schrieb Thiago Farina:
> >> kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer
> >>
> >
> > I don't know where you get this kind of warning. But passing 0 for a
> > NULL pointer is ANSI C standard.
> 
> NACK?

Acked-by: Stefani Seibold <stefani@seibold.net>


