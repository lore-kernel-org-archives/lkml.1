Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZEaPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZEaPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZEaPYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 11:24:19 -0400
Received: from hera.cwi.nl ([192.16.191.8]:35737 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZEaPYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 11:24:19 -0400
Date: Sun, 31 May 2009 17:24:03 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area
	handling
Message-ID: <20090531152403.GA26987@ub>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 04:39:11PM +0200, Bartlomiej Zolnierkiewicz wrote:

[HPA stuff deleted]

Hi Bartlomiej,

Apart from HPA one also has DCO, which functions rather similarly.
(I have not checked whether the current kernel knows anything about DCO.)
Have you thought about DCO?
Probably the kernel should by default not touch any such setting.
Maybe it should be reported?
A user space utility might change this setting - thus a disk can change size.

Andries

