Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXJ2MLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXJ2MLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXJ2MLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:11:18 -0400
Received: from ns.suse.de ([195.135.220.2]:40505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXJ2MLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:11:17 -0400
To: Yoav Artzi <yoavar@checkpoint.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux kernel memory and split on 64-bit machines
From: Andi Kleen <andi@firstfloor.org>
References: <4725C1EB.10205@checkpoint.com>
Date: Mon, 29 Oct 2007 13:11:15 +0100
In-Reply-To: <4725C1EB.10205@checkpoint.com> (Yoav Artzi's message of "Mon\, 29 Oct 2007 13\:20\:11 +0200")
Message-ID: <p73abq23yu4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoav Artzi <yoavar@checkpoint.com> writes:

> I am researching now about the Linux kernel memory on 64-bit (x86_64)
> machines. I am looking into answering the following questions:
>
> 1. Is there a user-kernel split on 64-bit memories? If so, how is it
> done? What is the size of each part?

See Documentation/x86_64/mm.txt. Note it changed in 2.6.11.

-Andi
