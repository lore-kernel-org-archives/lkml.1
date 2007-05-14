Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXENR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXENR13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXENR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:27:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbXENR1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:27:23 -0400
Message-ID: <46489BF6.1010202@redhat.com>
Date: Mon, 14 May 2007 13:27:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Nbd problem now oopses.
References: <20070513131807.GA10663@bitwizard.nl>
In-Reply-To: <20070513131807.GA10663@bitwizard.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff wrote:
> ...
> [ 5628.608000] Code: d2 89 d5 74 26 83 be 80 01 00 00 00 0f 85 7b 03 00 00 c7 86 88 01 00 00 00 00 00 00 8b 5c 24 1c 89 9e 80 01 00 00 e9 62 03 00 00 [ 5628.608000] EIP: [<c0293210>] tcp_sendmsg+0x726/0xab3 SS:ESP 0068:c3f8fc5c
> 

A big chunk of the machine code is missing here, so it's impossible to tell what really happened.
