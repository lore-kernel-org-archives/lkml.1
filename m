Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYGVXiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYGVXiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbYGVXh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:37:27 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:54127 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758201AbYGVXhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:37:25 -0400
Date: Tue, 22 Jul 2008 19:37:22 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080722233722.GA12247@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
    I am unclear on what you want to push. Are you referring
to the mmconf_end_bus_num_detect.patch and mmconf_end_bus_num_detect_fix.patch
fixes that are already in -tip? These work fine in allowing MMCONFIG to work
on my MacBook Pro and should go into the stable kernel. If you are talking
about blacklisting pcie pre1.1 devices to solve the problems with ASPM,
I really don't understand how I do that (in terms of finding out what devices
to blacklist).
                     Jack
   
