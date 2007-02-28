Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXB1S5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXB1S5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbXB1S5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:57:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXB1S5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:57:20 -0500
Date: Wed, 28 Feb 2007 13:55:05 -0500
From: Dave Jones <davej@redhat.com>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@hp.com>,
       Kevin Stansell <kstansel@us.ibm.com>
Subject: Re: [patch] Add insmod option to force the use of the backup timer.
Message-ID: <20070228185505.GA17193@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
	Alex Williamson <alex.williamson@hp.com>,
	Kevin Stansell <kstansel@us.ibm.com>
References: <20070228102346.115707000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228102346.115707000@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 11:23:46AM +0100, Gerd Hoffmann wrote:
 > The test which automatically enables the backup timer on some HP
 > machines doesn't trigger on other hardware which needs the backup
 > timer too.

Did you figure out *why* that test doesn't trigger?
Making that work seems a better solution to me than adding magic
options that users won't know they have to use.

		Dave

-- 
http://www.codemonkey.org.uk
