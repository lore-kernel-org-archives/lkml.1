Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbYEAQBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbYEAQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbYEAQBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:01:37 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:25770 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350AbYEAQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:01:36 -0400
X-IronPort-AV: E=Sophos;i="4.27,422,1204520400"; 
   d="scan'208";a="14076308"
Date: Thu, 1 May 2008 17:01:29 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: This month's price for the most useless new Kconfig help text ...
Message-ID: <20080501160129.GU4797@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, torvalds@osdl.org
References: <20080501120959.GA16700@basil.nowhere.org> <20080501131900.GL4797@implementation.uk.xensource.com> <20080501154720.GA3476@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080501154720.GA3476@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 01 May 2008 16:01:35.0307 (UTC) FILETIME=[A187B1B0:01C8ABA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig, le Thu 01 May 2008 11:47:20 -0400, a écrit :
> On Thu, May 01, 2008 at 02:19:00PM +0100, Samuel Thibault wrote:
> > If the society was a bit more aware of accessibility troubles in general
> > (I mean in the street etc.), we wouldn't have to explain the word
> 
> Blah, an agenda is not an excuse for bad option descriptions.

Sure, that's why I provided a patch :)

(I agree that Kconfig helps like "CONFIG_FUSION: Say Y here to get to
see options for Fusion Message Passing Technology (MPT) drivers" do not
help much, I just didn't know that people were now actually caring about
having some real explanations beyond the usual "if you don't know what
it is, you don't need it, just say no")

> And btw, the word accessibility in the sense used here doesn't translate
> at all into many foreign languages,

Right.

Samuel
