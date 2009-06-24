Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZFXWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZFXWzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZFXWzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:55:40 -0400
Received: from windsormachine.com ([216.8.138.2]:48952 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbZFXWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:55:39 -0400
Message-ID: <4A42AEEC.9070002@windsormachine.com>
Date: Wed, 24 Jun 2009 18:55:40 -0400
From: Mike Dresser <mdresser_l@windsormachine.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mathias Kretschmer <mathias@blx4.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906092111.54073.mathias@blx4.net> <alpine.DEB.1.10.0906091521470.9067@router.windsormachine.com> <200906182355.57100.mathias@blx4.net>
In-Reply-To: <200906182355.57100.mathias@blx4.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried 2.6.30-git18 the other day, machine jammed up with the usual BUG, 
though it was on radix-tree.c:464 this time.

I really should get around to putting an APC masterswitch on this 
server, since it won't reboot with anything but the power 
switch/reset(though the system is otherwise fine, interactivity is 
perfect.. just can't kill processes)

Mike


