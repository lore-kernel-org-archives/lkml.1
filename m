Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZHSONa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZHSONa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZHSON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:13:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48995 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZHSON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:13:28 -0400
Date: Wed, 19 Aug 2009 15:13:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] dell-laptop: poll the rfkill hard-block
Message-ID: <20090819141322.GA15937@srcf.ucam.org>
References: <4A8C0623.8030808@tuffmail.co.uk> <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 03:06:51PM +0100, Alan Jenkins wrote:
> This is controlled by a hardware switch, so we should poll it in order
> to pick up changes.  (There does not appear to be an interrupt or any
> other notification mechanism).

With the exception of this one they all look fine - I'm moving house 
next week and won't have access to any Dell hardware for over a month, 
so if anyone else could confirm that these work that would be excellent.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
