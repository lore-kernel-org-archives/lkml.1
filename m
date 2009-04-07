Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbZDGSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbZDGSKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZDGSKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:10:38 -0400
Received: from smtp-out-43.synserver.de ([217.119.50.43]:1073 "HELO
	smtp-out-43.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755170AbZDGSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:10:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 21353
Date: Tue, 7 Apr 2009 20:10:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <willy@linux.intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Message-ID: <20090407181033.GA2673@gentoox2.trippelsdorf.de>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DB8B54.7050402@garzik.org> <49DB9422.5040702@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DB9422.5040702@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 01:57:54PM -0400, Mark Lord wrote:
> Are there any commercially available SSDs that have this feature yet?
> Anyone know which ones?

OCZ will release a new firmware for their Vertex line in the coming
days, which will feature ATA TRIM support.
And since they get their firmware directly from Indilinx, all SSDs
with this controller will be TRIM ready in the future.

http://www.ocztechnologyforum.com/forum/showthread.php?t=54373

-- 
Markus
