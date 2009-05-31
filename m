Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZEaOj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZEaOj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZEaOjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:39:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36730 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbZEaOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:39:20 -0400
Message-ID: <4A22967C.3080304@redhat.com>
Date: Sun, 31 May 2009 10:38:52 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: research@subreption.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
       alan@lxorguk.ukuu.org.uk, linux-crypto@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and key/iv
 handling
References: <20090531025720.GC9033@oblivion.subreption.com> <20090530.230213.73434433.davem@davemloft.net>
In-Reply-To: <20090530.230213.73434433.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Larry H." <research@subreption.com>
> Date: Sat, 30 May 2009 19:57:20 -0700
> 
>> [PATCH] Use kzfree in crypto API context initialization and key/iv handling
> 
> Thanks for not CC:ing the crypto list, and also not CC:'ing the
> crypto maintainer.
> 
> Your submissions leave a lot to be desired, on every level.

That's a pretty roundabout way of saying "I have no
technical objections" :)

-- 
All rights reversed.
