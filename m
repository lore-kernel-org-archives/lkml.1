Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZKMWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZKMWC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZKMWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:02:22 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47545 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZKMWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:02:22 -0500
Date: Fri, 13 Nov 2009 22:02:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/3] setup: Store the boot cursor state
Message-ID: <20091113220220.GA7233@srcf.ucam.org>
References: <1258142222-16092-1-git-send-email-mjg@redhat.com> <4AFDD4D3.4060909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFDD4D3.4060909@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 01:51:15PM -0800, H. Peter Anvin wrote:

> I'm cool with this, but please update the appropriate files in
> Documentation/x86 as well.

It's in screen_info rather than the zero page - is there any relevant 
documentation to update?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
