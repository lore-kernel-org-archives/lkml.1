Return-Path: <linux-kernel-owner+w=401wt.eu-S935207AbXHHOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207AbXHHOYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbXHHOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:23:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:44264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXHHOX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:23:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH 13/25] [PATCH] turn msr.h functions into native versions
Date: Wed, 8 Aug 2007 16:23:53 +0200
User-Agent: KMail/1.9.6
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081125.38481.ak@suse.de> <5d6222a80708080719k2e2723mdf82572624856246@mail.gmail.com>
In-Reply-To: <5d6222a80708080719k2e2723mdf82572624856246@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081623.53754.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The instruction is called rdtscp not read_tscp. Please follow that
> 
> Although the operation consists in reading tscp. 

There is no tscp register

-Andi
