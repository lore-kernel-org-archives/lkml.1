Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbZBLMr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbZBLMr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZBLMo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:44:27 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:59072 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812AbZBLMo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:26 -0500
Date: Thu, 12 Feb 2009 12:44:16 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: get/put unaligned helpers
In-Reply-To: <4993E2CA.1070408@panasas.com>
Message-ID: <alpine.LFD.1.10.0902121241570.7279@ftp.linux-mips.org>
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick> <4993E2CA.1070408@panasas.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Boaz Harrosh wrote:

> Speaking of which. When all this is done do you intend to also export
> the unaligned.h headers to user-mode just like the aligned Endian helpers?
> 
> That could help in a couple of projects, so you have my vote.

 Why would you need that?  GCC provides a portable, platform-independent 
way.  It has had it for ten years at the very least.

  Maciej
