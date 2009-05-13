Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbZEMWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbZEMWD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbZEMWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:03:40 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:52322 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbZEMWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:03:39 -0400
Date: Thu, 14 May 2009 00:04:36 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
Message-ID: <20090513220436.GD729@electric-eye.fr.zoreil.com>
References: <200905091403.n49E3fb5025843@mercury.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905091403.n49E3fb5025843@mercury.physics.adelaide.edu.au>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
[...]
> I am currently testing a Gigabyte EX58-UD4P mainboard which is equipped with
> an onboard Realtek RTL-8168D network controller.  The kernel version is
> 2.6.29.2.  The r8169 module is loaded correctly, identifies the chip as an
> 8168D and seemingly is happy.  However, after loading the module the link
> remains dead.  The green and orange status LEDs remain off at all times.

Which XID does it display in dmesg when the module is inserted and which
behavior do you experience with version 8.011.00 of Realtek's r8168 driver ?

-- 
Ueimor
