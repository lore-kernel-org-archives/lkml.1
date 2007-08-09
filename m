Return-Path: <linux-kernel-owner+w=401wt.eu-S939266AbXHIPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939266AbXHIPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbXHIPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:25:12 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3749 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760191AbXHIPZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:25:10 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.23-rc2-mm1: kernel BUG at mm/swap_state.c:78!
Date: Thu, 9 Aug 2007 17:25:07 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <200708091711.53898.m.kozlowski@tuxland.pl> <20070809151435.GB16717@stusta.de>
In-Reply-To: <20070809151435.GB16717@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091725.07636.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >...
> > Not sure why it says kernel was tainted though ... hmmm.
> >...
> 
> What does your syslog say when it was tainted?

Shit. My fault. I'll try to reproduce it on untainted kernel.

Thanks,

	Mariusz
