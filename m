Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbXKDRS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbXKDRS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXKDRSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:18:18 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:54663 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXKDRSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:18:17 -0500
Date: Sun, 4 Nov 2007 09:18:16 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: TCP_DEFER_ACCEPT issues
In-Reply-To: <20071102221912.GB4354@codeblau.de>
Message-ID: <alpine.DEB.0.9999.0711040916210.4696@twinlark.arctic.org>
References: <20071102013321.GA30893@codeblau.de> <472AD0AE.50106@cosmosbay.com> <20071102221912.GB4354@codeblau.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fwiw i also brought the TCP_DEFER_ACCEPT problems up the end of last year:

http://www.mail-archive.com/netdev@vger.kernel.org/msg28916.html

it's possible the final message in that thread is how we should define the 
behaviour, i haven't tried the TCP_SYNCNT idea though.

-dean
