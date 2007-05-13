Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbXEMSqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbXEMSqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbXEMSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:46:05 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:2839 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706AbXEMSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:46:02 -0400
Date: Sun, 13 May 2007 20:45:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rodrigo Amestica <ramestic@nrao.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: is linux still a none swappable kernel?
Message-ID: <20070513184522.GA9819@osiris.ibm.com>
References: <464746EC.10608@nrao.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464746EC.10608@nrao.edu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 01:12:12PM -0400, Rodrigo Amestica wrote:
> In some older posts I have read that memory allocations via kmalloc
> and vmalloc are not swappable, that is, these memory chunks are not
> paged out to swap area. Is this still the case with linux kernel 2.6?

Yes.
