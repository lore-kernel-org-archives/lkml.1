Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZFGUJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZFGUJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZFGUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:09:22 -0400
Received: from windsormachine.com ([216.8.138.2]:47411 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZFGUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:09:21 -0400
Date: Sun, 7 Jun 2009 16:09:23 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <AN6kEAA5GQ.A.WDB.xj7KKB@chimera>
Message-ID: <alpine.DEB.1.10.0906071608010.3914@router.windsormachine.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.WDB.xj7KKB@chimera>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).

Still testing, but so far 2.6.30-rc8(or another RC) seems to have fixed 
this.  I'd say to leave this open for now, there's at least one other 
person testing 2.6.30-rc8 to see if it's fixed or not.

Mike

