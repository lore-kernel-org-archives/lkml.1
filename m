Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYBDPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYBDPyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYBDPyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:54:15 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:44513 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYBDPyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:54:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18343.13598.546459.760900@stoffel.org>
Date: Mon, 4 Feb 2008 10:54:06 -0500
From: "John Stoffel" <john@stoffel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] firewire-sbp2: misc hotplug related patches
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> I got quite good results with several OxSemi based SBP-2
Stefan> devices, also with an Initio based dual-LU device and LSI
Stefan> based devices.  A Prolific PL-3505 based device with known
Stefan> buggy firmware didn't work too well; I don't know if (but
Stefan> doubt that) the ieee1394 stack would do better. 

I've completely given up on my Firewire/USB external enclosure with a
PL-3xxx chipset.  Do you want it for further testing purposes?  I'd be
happy to ship it to you if you like.  

John
