Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYFZFGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYFZFGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYFZFGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:06:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:46309 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYFZFGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:06:04 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200806242055.12042.bzolnier@gmail.com>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1214303693.8011.345.camel@pasglop> <200806242051.22207.bzolnier@gmail.com>
	 <200806242055.12042.bzolnier@gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 14:54:54 +1000
Message-Id: <1214456094.8011.438.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW (usual problem), I'm having a very hard time applying your patches..

It looks like the 2 replacement ones you sent are no longer against
whatever merge point I found in linux-next history for your tree, so
I applied against linux-next 20080620, where 1/4 applies, 2/4 applies
with offsets and 3 fails...

For some reason, every time you send me new patches, I need more time
figuring out what they are supposed to apply to than actually testing
them :-)

Cheers,
Ben.


