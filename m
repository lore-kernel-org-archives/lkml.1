Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbXFOUKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbXFOUKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXFOUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:10:47 -0400
Received: from gw.goop.org ([64.81.55.164]:49913 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbXFOUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:10:46 -0400
Message-ID: <4672F240.7060106@goop.org>
Date: Fri, 15 Jun 2007 13:10:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: asm-sh64/module.h defines 32 bit ELF types
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm doing a little cleanup of ELF stuff around the tree, and I noticed
that asm-sh64/module.h defines 32 bit versions of the ELF types rather
than 64.  Is this right?

Seems counterintuitive to me...

    J
