Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbYJSTMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbYJSTMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 15:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJSTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 15:12:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60194 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYJSTME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 15:12:04 -0400
Date: Sun, 19 Oct 2008 21:11:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: ROASCIO Paolo <roa@libero.it>
cc: linux-kernel@vger.kernel.org
Subject: Re: hex code shown at boot
In-Reply-To: <200810191630.43517.roa@libero.it>
Message-ID: <alpine.LRH.1.10.0810192111240.2000@twin.jikos.cz>
References: <200810191630.43517.roa@libero.it>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, ROASCIO Paolo wrote:

> I need to know something about the strange boot output i obtain in console 
> after a (mm and others patched, but the vanilla give me the same results) 
> 2.6.22.1 compile. Yes. i know this is a very old version, but it's the last i 
> can patch to recognize my Flydvb Trio multiple frontends.
> Attached (because are very long) are both my relevant part of kern.log, the 
> dmesg output and the .config i used.

Do you get the dump also when you do not user framebuffer console? (i.e. 
boot with vga=normal).

-- 
Jiri Kosina
SUSE Labs

