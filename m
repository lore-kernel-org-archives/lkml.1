Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXHWHOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXHWHOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXHWHO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:14:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbXHWHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:14:26 -0400
Date: Thu, 23 Aug 2007 09:14:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Pavel Machek <pavel@ucw.cz>, Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
In-Reply-To: <486902.58063.qm@web36612.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0708230913500.12788@fbirervta.pbzchgretzou.qr>
References: <486902.58063.qm@web36612.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 22 2007 11:47, Casey Schaufler wrote:
>> As we have to maintain selinux, anyway, I don't see why simplification
>> layer is a problem.
>
>It's an issue if you want to do simple things, have the resources to
>do simple things, but go over budget because the simple things are
>built on top of complex things that you don't need. I see this crop
>up frequently with IT infrastructures, where simple problems get
>solved using completely unnecessary components just because those
>components are available.

class LinkedList {} for example. Just look how simple the linux
kernel does it ;-)


	Jan
-- 
