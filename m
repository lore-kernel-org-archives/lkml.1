Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYBHRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYBHRT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964854AbYBHRHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:07:53 -0500
Received: from mail.suse.de ([195.135.220.2]:45186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844AbYBHRHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:07:51 -0500
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Automated Kernel Testing
From: Andi Kleen <andi@firstfloor.org>
References: <47A50EF8.6020507@gmail.com>
Date: Fri, 08 Feb 2008 18:07:50 +0100
In-Reply-To: <47A50EF8.6020507@gmail.com> (Kevin Winchester's message of "Sat\, 02 Feb 2008 20\:46\:48 -0400")
Message-ID: <p73abmb2x7d.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester <kjwinchester@gmail.com> writes:

>
> - For people like me, it would be great if there were a downloadable
> collection of tools for performing similar testing on my box here
> whenever I'm not using it.
> - The tools could build a kernel, boot it, run some standard tests, and
> report any problems automatically.

ftp.suse.com:/pub/people/ak/autoboot/autoboot-1.tgz 
together with autotest does most of this. It however assumes that you
have multiple machines and controls test machines from a central server.
autotest alone can also do some tests on a single machine.

-Andi
