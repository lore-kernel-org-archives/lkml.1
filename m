Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZECK7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZECK7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 06:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZECK7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 06:59:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51173 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZECK7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 06:59:34 -0400
Date: Sun, 3 May 2009 11:59:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bank screen after resume on Dell XPS M1330
Message-ID: <20090503105932.GA18170@srcf.ucam.org>
References: <200905031111.50789.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905031111.50789.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey Borzenkov wrote:
> 01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M GS 
> (rev a1)

We don't know how to reinitialise nvidia graphics hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
