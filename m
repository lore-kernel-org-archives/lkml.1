Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYE2IPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYE2IPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYE2IP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:15:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40374 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYE2IP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:15:26 -0400
Date: Thu, 29 May 2008 09:15:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Message-ID: <20080529081510.GB16444@srcf.ucam.org>
References: <20080528130621.GA32646@srcf.ucam.org> <20080528132152.GB32646@srcf.ucam.org> <20080528223225.51cf8298.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528223225.51cf8298.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RESEND: [PATCH 2/3] ACPI: Send switch event on dock events
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:32:25PM -0700, Andrew Morton wrote:

> Is CONFIG_ACPI_DOCK=y, CONFIG_INPUT=n possible?  I think so..

Possible, but inconsistent. I'll fix that up.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
