Return-Path: <linux-kernel-owner+w=401wt.eu-S1946224AbXD3Q1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946224AbXD3Q1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946349AbXD3Q1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:27:32 -0400
Received: from mail.suse.de ([195.135.220.2]:47258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946288AbXD3Q11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:27:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Bryan O'Sullivan" <bos@pathscale.com>
Subject: Re: [patches] [PATCH] [8/35] x86_64: a memcpy that tries to reducecache pressure
Date: Mon, 30 Apr 2007 18:25:59 +0200
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>, Roland Dreier <rolandd@cisco.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
References: <20070428752.712152000@suse.de> <200704301104.26478.ak@suse.de> <463615D5.1050508@pathscale.com>
In-Reply-To: <463615D5.1050508@pathscale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301825.59974.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 18:14:13 Bryan O'Sullivan wrote:
> Andi Kleen wrote:
> 
> > Yes I remember, somehow it got lost. I agree it's a bad thing. Will drop
> > the patch for now especially since nothing seems to really need it right now.
> 
> It would be used by the ipath driver if it was around.

Please address the feedback from Jan then and I can remerge it then

-Andi
