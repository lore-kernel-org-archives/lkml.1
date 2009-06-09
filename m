Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZFITWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZFITWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbZFITWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:22:14 -0400
Received: from windsormachine.com ([216.8.138.2]:42780 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZFITWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:22:14 -0400
Date: Tue, 9 Jun 2009 15:22:16 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Mathias Kretschmer <mathias@blx4.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <200906092111.54073.mathias@blx4.net>
Message-ID: <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906080940.14650.posting@blx4.net> <alpine.DEB.1.10.0906091457510.28108@router.windsormachine.com> <200906092111.54073.mathias@blx4.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Mathias Kretschmer wrote:

> machine is stable for the last 36 hours with nfs turned off.

Is the system load different with nfs off? (no clients accessing it, etc?)

Mike

