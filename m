Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYIJQXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYIJQXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYIJQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:23:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33379 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYIJQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:23:30 -0400
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pierre Morel <pmorel@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
In-Reply-To: <20080910162008.GA401@tv-sign.ru>
References: <48C51439.7000706@linux.vnet.ibm.com>
	 <20080909124302.GA139@tv-sign.ru> <48C7E3A9.3060602@linux.vnet.ibm.com>
	 <20080910162008.GA401@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:23:25 -0700
Message-Id: <1221063805.6781.11.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 20:20 +0400, Oleg Nesterov wrote:
> But... well, I think we need Roland's opinion. I must admit, I am a bit
> sceptical about this patch ;) I mean, I don't really understand why it
> is useful

Yeah, I don't think they're completely coming clean on it, yet.  

-- Dave

