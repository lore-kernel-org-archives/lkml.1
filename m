Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYJ2XWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYJ2XWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJ2XWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:22:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYJ2XWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:22:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
Date: Thu, 30 Oct 2008 00:27:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
In-Reply-To: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300027.19116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Peter Korsgaard wrote:
> Hi,
> 
> I'm seing what looks like a kobject reference count issue with
> mtdblock_ro + mtd_dataflash + mtd partitions and repeated unbind/bind.
> I'm on 2.6.28-rc2, but I can reproduce the problem on 2.6.27 as well.

Is it reproducible with 2.6.26 too?

Rafael
