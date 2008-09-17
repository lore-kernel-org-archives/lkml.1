Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYIQVsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYIQVsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYIQVsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:48:13 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41594 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYIQVsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:48:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
Date: Wed, 17 Sep 2008 15:48:04 -0600
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "April Tsui" <aprilla@gmail.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com> <200809170904.20535.bjorn.helgaas@hp.com> <dd18b0c30809171013w3afea64bw9c49e94afe72306a@mail.gmail.com>
In-Reply-To: <dd18b0c30809171013w3afea64bw9c49e94afe72306a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171548.04857.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 11:13:55 am Justin Mattock wrote:
> I've seeing something interesting at the moment
> with this. I've upgraded isight-firmware-tools to the latest,
> and instead of using udev I'm using hal. I've done numerous
> reboots, and am not receiving this message. I think it might have been
> something to do with ift-load. If I don't see this message after a few more days
> of rebooting, and cold starts I think we can close this.

Maybe the problem doesn't happen with different user-space
tools, but that doesn't mean the kernel problem is fixed. 

And we still don't know whether this is really a regression
or not.

Bjorn
