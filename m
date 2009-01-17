Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZAQBsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZAQBsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 20:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZAQBsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 20:48:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57023 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZAQBsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 20:48:40 -0500
Date: Sat, 17 Jan 2009 01:48:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hp-wmi: fix regressions caused by missing if statement
Message-ID: <20090117014833.GA1900@srcf.ucam.org>
References: <200901170013.55786.elendil@planet.nl> <200901170131.22541.elendil@planet.nl> <200901170155.02757.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901170155.02757.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 01:55:01AM +0100, Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
> 
> hp-wmi: fix regressions caused by missing if statement
>     
> Error was introduced in commit fe8e4e039dc3.
>     
> Signed-off-by: Frans Pop <elendil@planet.nl>

Signed-off-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
