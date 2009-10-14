Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbZJNPRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbZJNPRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934419AbZJNPRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:17:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51540 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319AbZJNPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:17:28 -0400
Date: Wed, 14 Oct 2009 16:16:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question regarding i5/i7 CPUs (1156) - Speed Bins
Message-ID: <20091014151648.GA8598@srcf.ucam.org>
References: <alpine.DEB.2.00.0910131953520.29143@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910131953520.29143@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 07:55:33PM -0400, Justin Piszcz wrote:
> Hello,
>
> In order to gain the acceleration e.g. 2.93GHz -> 3.6GHz for a single  
> thread, does one need to use a cpu daemon?

No. If you're in P0, the package will run cores at the highest speed it 
can given the current constraints.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
