Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZLKQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZLKQob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZLKQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:44:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50480 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZLKQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:44:29 -0500
Date: Fri, 11 Dec 2009 16:44:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] laptop-mode: Make flushes per-device
Message-ID: <20091211164433.GA1980@srcf.ucam.org>
References: <1260547727-6408-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260547727-6408-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I seem to have screwed up the includes somehow when I rebased 
this. I'm now trapped in a maze of twisty interdependencies, all 
different.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
