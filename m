Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbYEIP6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbYEIP6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbYEIP6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:58:33 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39052 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761156AbYEIP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:58:31 -0400
Date: Fri, 9 May 2008 11:58:31 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080509155830.GE6957@csclub.uwaterloo.ca>
References: <20080508161008.59361de5@appleyard> <20080508233713.GB15377@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508233713.GB15377@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 12:37:13AM +0100, Matthew Garrett wrote:
> Just out of interest, is this set on laptop bays? (Are any of those even 
> native SATA yet?)

My wife's Asus R1F does in fact have SATA in use for the drive bay and
allows swapping between the DVD-RW and a second HD (or another battery
if she had one) in that bay.  I would think many laptops do that now.

-- 
Len Sorensen
