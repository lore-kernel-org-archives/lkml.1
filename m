Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYJNWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYJNWDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYJNWDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:03:17 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:51263 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYJNWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:03:16 -0400
Date: Wed, 15 Oct 2008 00:03:14 +0200
From: FD Cami <francois.cami@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix numlock led on Dell keyboard (413c:2105)
Message-ID: <20081015000314.40845354@moria>
In-Reply-To: <20081014102821.2693b15e@pedra.chehab.org>
References: <20081014102821.2693b15e@pedra.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mauro,

On Tue, 14 Oct 2008 10:28:21 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This keyboard needs to re-sync numlock after probing.

Do you mean, when you plug one, the numlock LED is on but numlock
may be off ? 

Cheers

Francois
