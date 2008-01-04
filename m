Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYADMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYADMoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYADMn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:43:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYADMnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:43:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080104123529.GA27894@ZenIV.linux.org.uk>
References: <20080104123529.GA27894@ZenIV.linux.org.uk> <20080104112642.GY27894@ZenIV.linux.org.uk> <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com> <22924.1199449441@redhat.com> 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Dave Young <hidave.darkstar@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 04 Jan 2008 12:43:50 +0000
Message-ID: <23768.1199450630@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> My apologies, should've had coffee before posting.

Me too, probably.

> FWIW, this patch pile is getting ridiculous - it's what, original + 2 fixes
> in -mm + mine + this one?  Could you post the updated patch with all fixes
> and fixes to fixes folded into it?

I can, though Andrew usually objects to that.

David
