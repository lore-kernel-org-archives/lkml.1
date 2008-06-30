Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbYF3SWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbYF3SWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbYF3SWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:22:32 -0400
Received: from main.gmane.org ([80.91.229.2]:41744 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbYF3SWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:22:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Subject: Re: [PATCH 3/3] Fix copy_user on x86_64
Date: 30 Jun 2008 21:22:18 +0300
Message-ID: <5dlk0mdbqd.fsf@Hurtta06k.keh.iki.fi>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cs130027.pp.htv.fi
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 30 Jun 2008, Vitaly Mayatskikh wrote:
> > 
> > "For this reason, all patches should be submitting e-mail "inline".
> > WARNING:  Be wary of your editor's word-wrap corrupting your patch,
> > if you choose to cut-n-paste your patch."
> > 
> > My first thought was "should be attached inline".
> 
> Yeah, no, the "inline" there means literally as no attachment at all, but 
> inline in the normal mail.

And not as own mime body part with

Content-Disposition: inline


?


( As you see "inline" have several meanings. 

  yes. Some mail readers treats only first body part as 'inline'
  and other have 'attachments'.
)

/ Kari Hurtta


