Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXAaVmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXAaVmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXAaVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:42:08 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:59318 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbXAaVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:42:07 -0500
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1170241008.6512.10.camel@Homer.simpson.net>
References: <1170241008.6512.10.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 08:42:02 +1100
Message-Id: <1170279722.5389.19.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-01-31 at 11:56 +0100, Mike Galbraith wrote:
> Greetings,
> 
> I received the below upon first poke of firefox icon after a resume.  

Are you able to reproduce it reliably? Failing that, could you try
enabling some the kernel configuration options that help with debugging
memory corruption (slab corruption checking in particular will probably
be the most useful thing here).

Regards,

Nigel


