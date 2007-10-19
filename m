Return-Path: <linux-kernel-owner+w=401wt.eu-S966998AbXJSVJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966998AbXJSVJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966831AbXJSVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:08:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:55057 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966687AbXJSVIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:08:45 -0400
Date: Fri, 19 Oct 2007 23:08:28 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
In-Reply-To: <4719174A.7020004@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz>
References: <4719174A.7020004@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Gabriel C wrote:

> usually I'll wait for rc1 and test compile external module to see which 
> are broken and what need fixing but while I need virtualbox for some 
> tests I test compile it on current git and it failed badly. Maybe 
> something is missing from x86 merge ?

Trying 'make mrproper' first has high chances of fixing this I'd guess.

-- 
Jiri Kosina
