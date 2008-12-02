Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYLBUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYLBUbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYLBUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:30:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41941 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYLBUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:30:59 -0500
Date: Tue, 2 Dec 2008 20:30:55 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, greg@kroah.com,
       linux-acpi@vger.kernel.org, rpurdie@rpsys.net, ivdoorn@gmail.com
Subject: Re: [PATCH 2/2] misc: Add dell-laptop driver
Message-ID: <20081202203055.GA1456@srcf.ucam.org>
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202200544.GA31620@srcf.ucam.org> <20081202122222.5873ee86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202122222.5873ee86.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:22:22PM -0800, Andrew Morton wrote:

> No, acpi.h has a _few_ ACPI=n stubs:

Ah, yes. I'll send a patch for that to Len.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
