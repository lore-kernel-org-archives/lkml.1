Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525Ab0AUAPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0AUAPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240Ab0AUAPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:15:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0AUAPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:15:10 -0500
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how do YOU hack the linux kernel ?
From: Andi Kleen <andi@firstfloor.org>
References: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
Date: Thu, 21 Jan 2010 01:15:05 +0100
In-Reply-To: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com> (Ramagudi Naziir's message of "Tue, 19 Jan 2010 14:52:57 +0200")
Message-ID: <87ocko2u0m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramagudi Naziir <naziirr@gmail.com> writes:

> do you use vim ?
>
> If so, how do you open files you want to read/edit ?
> Assuming you don't remember their exact name/location, you'd need to
> use something like 'find . -iname '*pattern*'. which is slow.

GNU id-utils does that nicely (file name / symbol lookup)
I usually use it for symbol lookup.

I am not aware of a vim integration though, although
there's one for emacs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
