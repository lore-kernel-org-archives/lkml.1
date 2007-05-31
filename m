Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbXEaEFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbXEaEFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXEaEFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:05:31 -0400
Received: from gw.goop.org ([64.81.55.164]:58628 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbXEaEFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:05:31 -0400
Message-ID: <465E498A.8020206@goop.org>
Date: Wed, 30 May 2007 21:05:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: section mismatches
References: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
In-Reply-To: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Mostly from Andi's tree:
>
> WARNING: arch/i386/kernel/head.o(.note.Xen+0x68): Section mismatch: reference to .init.text:startup_xen
> WARNING: vmlinux(.notes+0x3d28): Section mismatch: reference to .init.text:startup_xen

Sam has the modpost patch to fix these two.

    J
