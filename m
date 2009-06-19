Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZFSPRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZFSPRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZFSPQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:16:54 -0400
Received: from windsormachine.com ([216.8.138.2]:56834 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZFSPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:16:53 -0400
Date: Fri, 19 Jun 2009 11:16:55 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Mathias Kretschmer <mathias@blx4.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <200906182355.57100.mathias@blx4.net>
Message-ID: <alpine.DEB.1.10.0906191116300.29718@router.windsormachine.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906092111.54073.mathias@blx4.net> <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com> <200906182355.57100.mathias@blx4.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Mathias Kretschmer wrote:

> I've upgraded to 2.6.30 two days ago. So far, so good.

Mine still crashes, so I've gone back to 2.6.28.9 for now.

