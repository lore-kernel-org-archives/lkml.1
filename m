Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXBKXUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXBKXUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXBKXUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:20:05 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:54037 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbXBKXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:20:02 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
In-Reply-To: <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>
	 <20070211064636.GA12171@1wt.eu>
	 <1171234027.4493.88.camel@nigel.suspend2.net>
	 <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:20:00 +1100
Message-Id: <1171236000.4493.116.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 02:57 +0400, Manu Abraham wrote:
> On 2/12/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> 
> > Neither am I. I'm just asking that new drivers have power management as
> > standard.

> What if the hardware doesn't support power management ?

You would still want to do the cleanup and configuration that you'd do
for module load/unload.

Regards,

Nigel

