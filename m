Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZFORZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZFORZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbZFORZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:25:19 -0400
Received: from windsormachine.com ([216.8.138.2]:47044 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZFORZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:25:18 -0400
Message-ID: <4A3683FF.8040500@windsormachine.com>
Date: Mon, 15 Jun 2009 13:25:19 -0400
From: Mike Dresser <mdresser_l@windsormachine.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mike Dresser <mdresser_l@windsormachine.com>
CC: Mathias Kretschmer <mathias@blx4.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906080940.14650.posting@blx4.net> <alpine.DEB.1.10.0906091457510.28108@router.windsormachine.com> <200906092111.54073.mathias@blx4.net> <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-rc8 still has issues, even with swapoff -a, it still died in kswapd0

