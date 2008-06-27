Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYF0NS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYF0NS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYF0NSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:18:36 -0400
Received: from vena.lwn.net ([206.168.112.25]:36939 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYF0NSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:18:34 -0400
Date: Fri, 27 Jun 2008 07:18:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
       swhiteho@redhat.com, sfrench@samba.org, vandrove@vc.cvut.cz
Subject: Re: [PATCH] Remove BKL from remote_llseek v2
Message-ID: <20080627071832.66bd97be@bike.lwn.net>
In-Reply-To: <20080627090524.GA2250@basil.nowhere.org>
References: <20080627090524.GA2250@basil.nowhere.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 11:05:24 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Andrew, can you please consider this patch for -mm? 
> I sent it to Jonathan earlier, but he ignored it.

Hmm, I sure didn't do that deliberately.  My apologies if it fell
through the cracks.  Ah, I see, I had set it aside with the fasync
stuff, sorry.

I can pull it into the BKL-removal tree, certainly.  Better late than
never?

jon
