Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZCWPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZCWPGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZCWPEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:04:49 -0400
Received: from michelle.daybyday.de ([85.183.245.167]:44751 "EHLO
	michelle.daybyday.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbZCWPEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:04:48 -0400
From: Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>
To: Rui Santos <rsantos@grupopie.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Mon, 23 Mar 2009 16:04:40 +0100
User-Agent: KMail/1.9.7
Cc: Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
References: <200903041828.49972.m.bueker@berlin.de> <200903231529.18064.m.bueker@berlin.de> <49C7A370.9070601@grupopie.com>
In-Reply-To: <49C7A370.9070601@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200903231604.40691.m.bueker@berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009, Rui Santos wrote:
> 3) If I compile the kernel without MSI/MSI-X support, I can't also
> reproduce the problem. You may test it by booting with pci=nomsi

I hate to make things more complicated, but my laptop doesn't use MSI (in 
fact, it doesn't even seem to support it), but still I see our error occur.

Michael

-- 
Num mihi dolebit hoc?
// This isn't going to hurt, is it?

>From "Practical Latin" by Henry Beard
