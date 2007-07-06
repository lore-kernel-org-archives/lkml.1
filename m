Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbXGFMpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbXGFMpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762511AbXGFMpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:45:19 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48369 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404AbXGFMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:45:18 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 14:45:11 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707060930.21348.oliver@neukum.org> <m3zm29pv4m.fsf@ursa.amorsen.dk>
In-Reply-To: <m3zm29pv4m.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061445.12295.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 6. Juli 2007 schrieb Benny Amorsen:
> >>>>> "ON" == Oliver Neukum <oliver@neukum.org> writes:
> 
> ON> Because we will be unable to escape that job. Let's assume that we
> ON> remove the freezer from the STR path. The next complaint would be
> ON> that we cannot do STD with fuse. "Then don't do that" would not be
> ON> taken kindly as answer.
> 
> Ah, we are back to keeping STR broken in order to maybe get STD
> working. STR is much more interesting than STD.

I am sorry, but we cannot live with only fixing parts of the kernel because
you don't think the other parts are interesting.

	Oliver
