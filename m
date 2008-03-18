Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbYCRHyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbYCRHyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYCRHy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:54:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45147 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYCRHy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:54:29 -0400
Message-ID: <47DF752C.608@garzik.org>
Date: Tue, 18 Mar 2008 03:54:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Adam J. Richter" <adam@yggdrasil.com>
CC: tiwai@suse.de, pshou@realtek.com.tw, matt.jared@intel.com,
       andy.kopp@intel.com, dan.d.kogan@intel.com,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: intel-hda sound too quiet in linux-2.6.25-rc6
References: <20080318062359.GA19453@freya.yggdrasil.com>
In-Reply-To: <20080318062359.GA19453@freya.yggdrasil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam J. Richter wrote:
>         I have a motherboard that uses the AMD am690g chip set,
> which has a sound hardware called "azalia", which apparently is
> controlled by linux/sound/pci/hda/hda_intel.c.

ACK, I have the same problem here:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)

