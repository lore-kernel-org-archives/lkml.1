Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbXBWPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbXBWPps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXBWPps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:45:48 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1356 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbXBWPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:45:48 -0500
Message-ID: <45DF0C29.2080201@xs4all.nl>
Date: Fri, 23 Feb 2007 16:45:45 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>	<20070221224027.GK22464@csclub.uwaterloo.ca>	<200702212355.25601.s0348365@sms.ed.ac.uk> <m3bqjnrntu.fsf@maximus.localdomain>
In-Reply-To: <m3bqjnrntu.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Small update:

I will try a different case with a different dual PCI riser card soon.
This Morex riser has DN20-31 or so, so more options.
Could this help solve my irq issue? (try 4 consecutive DNs until I have
the right mapping?)

Kind regrads,
Udo
