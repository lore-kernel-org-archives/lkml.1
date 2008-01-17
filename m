Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbYAQL1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbYAQL1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYAQL1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:27:35 -0500
Received: from mail.suse.de ([195.135.220.2]:49924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYAQL1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:27:34 -0500
From: Andi Kleen <ak@suse.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
Date: Thu, 17 Jan 2008 12:27:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200801161127.268350000@suse.de> <20080116222706.8074A14EE3@wotan.suse.de> <1200538738.17967.4.camel@brick>
In-Reply-To: <1200538738.17967.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171227.06307.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008 03:58:58 Harvey Harrison wrote:
> On Wed, 2008-01-16 at 23:27 +0100, Andi Kleen wrote:
> > Signed-off-by: Andi Kleen <ak@suse.de>
> >
> > ---
> >  arch/x86/mm/fault_32.c |    2 +-
>
> Could use exactly the same in fault_64.c

Hmm, I had this somewhere but it might have gotten lost during 
some merge step again.

-Andi
