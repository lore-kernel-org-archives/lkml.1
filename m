Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXHVLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXHVLJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbXHVLJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:09:38 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:49256 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXHVLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:09:37 -0400
Date: Wed, 22 Aug 2007 13:09:13 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: huge improvement with per-device dirty throttling
Message-ID: <20070822130913.643c39be@localhost>
In-Reply-To: <p733aybzv6e.fsf@bingen.suse.de>
References: <1187764638.6869.17.camel@hannibal>
	<p733aybzv6e.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug 2007 13:05:13 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> "Jeffrey W. Baker" <jwbaker@acm.org> writes:
> > 
> > My system is a Core 2 Duo, 2GB, single SATA disk.  
> 
> Hmm, I thought the patch was only supposed to make a real difference
> if you have multiple devices? But you only got a single disk.  

No, there's also:
[PATCH 22/23] mm: dirty balancing for tasks

:)

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
