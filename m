Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZFZQnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZFZQnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFZQm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:42:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42076 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbZFZQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:42:56 -0400
Date: Fri, 26 Jun 2009 17:44:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 26 (cyclades)
Message-ID: <20090626174414.12ce9291@lxorguk.ukuu.org.uk>
In-Reply-To: <4A44F18D.2000608@oracle.com>
References: <20090626154605.ac73b738.sfr@canb.auug.org.au>
	<4A44F18D.2000608@oracle.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 09:04:29 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090625:
> 
> 
> drivers/char/cyclades.c:3332: error: assignment of read-only location

Fixed
