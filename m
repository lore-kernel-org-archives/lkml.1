Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXHVLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXHVLjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXHVLjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:39:37 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:39364 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbXHVLjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:39:36 -0400
Date: Wed, 22 Aug 2007 12:39:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?utf-8?B?UmFmYcWC?= Maj <forlist@limcore.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070822113927.GA7633@srcf.ucam.org>
References: <20070822094915.41afa2af@lore.lcone>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070822094915.41afa2af@lore.lcone>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Calling BIOS interrupt from kernel (and debugging / reverse engeneering)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:49:15AM +0200, Rafał Maj wrote:

> AFAIK vm86() is one step to do it, but its hard to find good complete
> example at least for me.

Take a look at lrmi.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
