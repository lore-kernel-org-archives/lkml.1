Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbYD2Wpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbYD2Wpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYD2Wpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:45:35 -0400
Received: from 1wt.eu ([62.212.114.60]:3583 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760021AbYD2Wpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:45:34 -0400
Date: Wed, 30 Apr 2008 00:45:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [00/12] 2.6.24-stable review
Message-ID: <20080429224532.GN8474@1wt.eu>
References: <20080429184911.GA24199@suse.de> <481792A6.406@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481792A6.406@web.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:27:02PM +0200, Jörg-Volker Peetz wrote:
> How about this one?
> 
> http://lkml.org/lkml/2008/4/7/55

looks good indeed, and needs to be fixed in 2.4 too.
However it's still not in mailine, so the author needs
to ping the stable team when this gets merged (or repost
with stable on a CC line in the commit message, as Greg
recently told me :-))

Willy

