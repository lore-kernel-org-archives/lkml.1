Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZFCVUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZFCVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZFCVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:20:13 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:59342 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbZFCVUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:20:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] parport: quickfix the proc registration bug
Date: Wed, 3 Jun 2009 23:20:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090602155718.12461.87554.stgit@t61.ukuu.org.uk>
In-reply-To: <20090602155718.12461.87554.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906032320.11870.elendil@planet.nl>
X-OriginalArrivalTime: 03 Jun 2009 21:20:12.0218 (UTC) FILETIME=[148151A0:01C9E491]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Ideally we should have a directory of drivers and a link to the 'active'
> driver. For now just show the first device which is effectively the
> existing semantics without a warning.
> 
> This is an update on the original buggy patch that I then forgot to
> resubmit. Confusingly it was proposed by Red Hat, written by Etched
> Pixels fixed and submitted by Intel ...
> 
> Resolves-Bug: http://bugzilla.kernel.org/show_bug.cgi?id=9749
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Thanks Alan. Unfortunately I'm no longer able to test this as my printer 
is now connected via USB to my notebook's docking station instead of via 
a parport to my desktop (which was prompted to home server and moved to a 
different room).
