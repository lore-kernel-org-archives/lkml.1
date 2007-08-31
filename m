Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbXHaUW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbXHaUW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXHaUWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:22:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:45366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXHaUWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:22:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [RFC] 9p Virtualization Transports
Date: Fri, 31 Aug 2007 22:22:44 +0200
User-Agent: KMail/1.9.6
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org
References: <11883271601857-git-send-email-ericvh@gmail.com>
In-Reply-To: <11883271601857-git-send-email-ericvh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708312222.44948.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 20:52:36 Eric Van Hensbergen wrote:
> This patch set contains a set of virtualization transports for the 9p file
> system intended to provide a mechanism for guests to access a portion of the
> hosts name space without having to go through a virtualized network.  

It might be useful to convert UML's hostfs to something like this. It's essentially
the same.

-Andi
