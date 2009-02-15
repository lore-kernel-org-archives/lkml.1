Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZBOMaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZBOMaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZBOMaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:30:03 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36049 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbZBOMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:30:00 -0500
X-Sasl-enc: Q7SnucN7Wfk3ZM6TkJzDpOCC/WwTP5uamfGK4IuB5aSh 1234700999
Date: Sun, 15 Feb 2009 09:29:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexandre Rostovtsev <tetromino@gmail.com>,
       linux-kernel@vger.kernel.org, linux-laptop@vger.kernel.org
Subject: Re: [0/3] lenovo-sl-laptop : new driver for drivers/staging
Message-ID: <20090215122956.GB7660@khazad-dum.debian.net>
References: <20090214051214.359d4fd4@leftboat.lan> <20090214145256.GA7071@infradead.org> <1234627163.7293.196.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234627163.7293.196.camel@violet>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009, Marcel Holtmann wrote:
> > > Patches against 2.6.29-rc5 will be in following emails.
> > Please submit it to the kernel proper, not the staging tree.  Also
> > please just submit it in one patch instead of the split.
> 
> I can only second that. This is not a driver that belongs anywhere near
> the staging tree. It should be instead sent to the ACPI mailing list for
> review.
> 
> The staging tree should _NOT_ be used as a shortcut for upstream
> inclusion.

I don't think that was what was happening (I should hope nothing can
get promoted from staging without the usual reviews, anyway!), but
whatever.

We will be happy to review the driver in linux-acpi.  Submitting it as
a single patch against latest Linus is probably best.  Oh, and it
should be checkpatch-clean if it isn't already.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
