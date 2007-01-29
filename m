Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXAaHGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXAaHGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXAaHGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:06:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:56171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXAaHGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:06:12 -0500
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
References: <20070125113350.GA31068@elte.hu>
	<20070125180324.36E8B557CF8@chen.mtu.ru>
From: Andi Kleen <ak@suse.de>
Date: 29 Jan 2007 16:41:38 +0100
In-Reply-To: <20070125180324.36E8B557CF8@chen.mtu.ru>
Message-ID: <p73ejpd96x9.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> writes:

> Will it work with netconsole too? COM port is often missing in notebooks
> today.

It will work with some luck with firescope (in the worst case you
might need to disable suspend in ochi1394). Many laptops have firewire
ports.

ftp://ftp.firstfloor.org/pub/ak/firescope/

-Andi
 
