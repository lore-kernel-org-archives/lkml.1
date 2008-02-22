Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbYBVMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbYBVMTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYBVMSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:18:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:34289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbYBVMSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:18:35 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
From: Andi Kleen <andi@firstfloor.org>
References: <47BDE731.60801@goop.org>
	<alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org>
	<47BDEA5E.4070800@goop.org>
	<alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org>
Date: Fri, 22 Feb 2008 13:18:33 +0100
In-Reply-To: <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 21 Feb 2008 13\:38\:19 -0800 \(PST\)")
Message-ID: <p73lk5d89ra.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> (*) I keed, I keed. Of *course* I'll have to fix things like this in the 
> future too. But hopefully not quite as often.

The pragmatic solution would be to just fix the scripts to accept From
everywhere @)

-Andi
