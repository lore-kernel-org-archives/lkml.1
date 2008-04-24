Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbYDXOmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbYDXOmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYDXOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:42:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYDXOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:42:36 -0400
Message-ID: <48109C59.2010203@firstfloor.org>
Date: Thu, 24 Apr 2008 16:42:33 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>, jbarnold@MIT.EDU,
       francois.cami@free.fr, mail@earthworm.de
Subject: Re: A system for rebootless kernel security updates
References: <481098A4.50107@wpkg.org>
In-Reply-To: <481098A4.50107@wpkg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And those patent descriptions, by the way, remind the way kexec works
> ("A software module is hotpatched by loading a patch into memory and
> modifying an instruction in the original module to jump to the patch"),
> which was released much earlier... In essence, they patented kexec ;)

The basic patching idea is old and has been used many times, long
predating kexec. e.g. it's a common way to implement incremental linkers
too.

-Andi

