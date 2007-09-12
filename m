Return-Path: <linux-kernel-owner+w=401wt.eu-S969709AbXILOef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969709AbXILOef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969575AbXILOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:34:07 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:53942 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969554AbXILOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:34:05 -0400
Message-ID: <46E7F816.9080806@dawes.za.net>
Date: Wed, 12 Sep 2007 16:30:46 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: David Newall <david@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain> <46E7DEF8.50201@davidnewall.com> <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> p.s.  by "basic", i mean those boot-time parms defined by either
> "__setup()" or "early_param()".  which means that module writers
> should, as much as possible, stop using those macros to define
> command-line parameters for their modules.  that would go a long way
> to restoring some order, and allowing for some decent and readable
> documentation.

Are you forgetting that modules can often be compiled into the bzImage, 
too, making them genuine boot-time params?

Rogan

