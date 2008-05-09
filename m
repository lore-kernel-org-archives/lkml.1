Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbYEIQPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbYEIQPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYEIQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:14:58 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47890 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbYEIQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:14:57 -0400
Date: Fri, 9 May 2008 12:14:56 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080509161456.GF6957@csclub.uwaterloo.ca>
References: <20080508161008.59361de5@appleyard> <20080508233713.GB15377@srcf.ucam.org> <20080509155830.GE6957@csclub.uwaterloo.ca> <20080509160641.GA30219@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509160641.GA30219@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 05:06:41PM +0100, Matthew Garrett wrote:
> Genuinely SATA, or PATA bridged to SATA?

SATA drives using intel 945GM chipset which has two native SATA ports.

-- 
Len Sorensen
