Return-Path: <linux-kernel-owner+w=401wt.eu-S935356AbXJPSyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356AbXJPSyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbXJPSyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:54:07 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:36207 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765731AbXJPSyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:54:04 -0400
Date: Tue, 16 Oct 2007 19:53:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeremy Katz <katzj@redhat.com>
Cc: hmh@hmh.eng.br, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Message-ID: <20071016185351.GC25181@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192481110-9299-1-git-send-email-katzj@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 04:45:10PM -0400, Jeremy Katz wrote:
> There are standard keycodes for brightness and volume; map the events to
> emit them so that things work properly

We've been doing this in Ubuntu for a couple of years now, with no 
obvious difficulty.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
