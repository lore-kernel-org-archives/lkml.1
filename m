Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYAQViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYAQViU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYAQViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:38:09 -0500
Received: from 1wt.eu ([62.212.114.60]:1379 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYAQViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:38:08 -0500
Date: Thu, 17 Jan 2008 22:12:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080117211205.GE8953@1wt.eu>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117203416.GK23696@does.not.exist>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Thu, Jan 17, 2008 at 10:34:16PM +0200, Adrian Bunk wrote:
> do you insist on hearing the truth ("Sorry, I forgot to push."), or can 
> I tell you "I just wanted to see whether anyone notices." instead?  ;-)

:-)

I think we should intentionally do this test once in a while. Two days
ago I was informed that 2.6.20.21 (the latest 2.6.20 I pushed 3 months
ago) was not clonable nor pullable due to a problem with the HEAD
pointing to latest tag instead of latest commit. Since the error was
also present in my local tree, I'm certain that it remained there
unnoticed for 3 months !

Cheers,
Willy

