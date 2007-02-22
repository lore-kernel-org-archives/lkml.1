Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXBVBT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXBVBT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422852AbXBVBT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:19:28 -0500
Received: from khc.piap.pl ([195.187.100.11]:34027 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422850AbXBVBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:19:27 -0500
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
	<200702212355.25601.s0348365@sms.ed.ac.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 22 Feb 2007 02:19:25 +0100
In-Reply-To: <200702212355.25601.s0348365@sms.ed.ac.uk> (Alistair John Strachan's message of "Wed, 21 Feb 2007 23:55:25 +0000")
Message-ID: <m3bqjnrntu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan <s0348365@sms.ed.ac.uk> writes:

> One warning to you though, I found the riser to be pretty flaky, causing 
> bizarre lockups and periodic crashes of Linux. Maybe this is a Linux
> bug, but 
> it really didn't seem like it.

I don't know how it could be a Linux bug.

Perhaps mechanical problems with edge connector - PCI slot connections?
-- 
Krzysztof Halasa
