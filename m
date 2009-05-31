Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZEaWu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZEaWu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 18:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZEaWus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 18:50:48 -0400
Received: from hera.cwi.nl ([192.16.191.8]:39815 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbZEaWur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 18:50:47 -0400
Date: Mon, 1 Jun 2009 00:50:31 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Frans Pop <elendil@planet.nl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area
	handling
Message-ID: <20090531225030.GB27422@ub>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <200905312204.12549.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905312204.12549.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 10:04:11PM +0200, Frans Pop wrote:

> I conclude the following from reading the patches:
> - a HPA is always at the end of a disk, correct?

I recall from the days of PARTIES and BEER the description
of the Address Offset Mode. If that is enabled, LBA 0 points
at the start of the Host Protected Area.

Andries



