Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbYBMTja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbYBMTja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765335AbYBMTjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:39:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43892 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763863AbYBMTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:39:12 -0500
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080213052903.B1F1CDBA2@gherkin.frus.com>
References: <20080213052903.B1F1CDBA2@gherkin.frus.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 20:39:05 +0100
Message-Id: <1202931545.20209.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 23:29 -0600, Bob Tracy wrote:
> This isn't going to be terribly useful other than giving someone a
> heads-up there's a problem with something in 2.6.25-rc1 on the Alpha
> PWS 433au.  I get the usual messages out of "aboot", including
> 
> aboot: zero-filling 210392 bytes at 0xfffffc0000776740
> aboot: starting kernel vmlinux.new.gz with argument ro root=/dev/sda3
> 
> and then the screen background switches to red and the machine locks
> up solid.  No further console output.  Completely reproducible.  The
> 2.6.24 kernel is fine.
> 
> Unless someone has a good idea what's causing this, I see a massive
> "git bisect" project in my future.  Won't be able to spend any time with
> this until at least the weekend :-(.

Does: http://lkml.org/lkml/2008/1/28/100

help?

