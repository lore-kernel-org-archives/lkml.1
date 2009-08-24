Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZHXJG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZHXJG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZHXJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:06:56 -0400
Received: from relay.atmel.no ([80.232.32.139]:62842 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZHXJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:06:55 -0400
Date: Mon, 24 Aug 2009 11:06:50 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AVR32 Linux Kernel <kernel@avr32linux.org>
Subject: Re: [GIT PULL] AVR32 update for 2.6.31
Message-ID: <20090824110650.266f9d5b@hskinnemoen-d830>
In-Reply-To: <20090824105953.0865db37@hskinnemoen-d830>
References: <20090824105953.0865db37@hskinnemoen-d830>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> Please pull
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git avr32-arch

Hmm...make that

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

For some reason, git request-pull got it wrong...probably because I
pushed out an additional patch to avr32-arch which didn't make it all
the way to git.kernel.org before I generated the pull request.

Haavard
