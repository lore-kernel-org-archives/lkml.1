Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYHYXvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYHYXvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 19:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYHYXvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 19:51:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:8894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYHYXvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 19:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G67o3wZvFmCgA9HcOIRYuhk9qVUyBoAsjl2TAcWSyJciDCtd+Rod8uwqTPHw9MfrXl
         ZFQ/PFTswowgefyQkBzaPxu0Zt8vHec9jSReq+kV/09UgXTAF9d/D8nKDMgK4V1LhVDt
         qRfufJR7U06MU27V4Vv8UswJkRQfFD8AaYQ0g=
Date: Tue, 26 Aug 2008 03:53:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
Message-ID: <20080825235313.GA10540@x200.localdomain>
References: <20080825220137.19210.41857.stgit@tigger.helgaas> <20080825150525.6f1b5706@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825150525.6f1b5706@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 03:05:25PM -0700, Arjan van de Ven wrote:
> On Mon, 25 Aug 2008 16:01:38 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > These patches change various debug messages to use "[%04x:%04x]" for
> > PCI vendor/device IDs to follow the format used by lspci(8).
> 
> I hope you're adding a new whicked special format specifier for this
> ... taking a PCI dev struct as argument.
> 
> That's be really nice to have;-)

You should sign Treaty of the Non-Proliferation of Format Specifiers.

Untill too late...

