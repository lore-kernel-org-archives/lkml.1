Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbYJSXoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbYJSXoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYJSXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:44:47 -0400
Received: from mail.anarazel.de ([217.115.131.40]:56181 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYJSXoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:44:46 -0400
From: Andres Freund <andres@anarazel.de>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 01:44:44 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200111.06461.andres@anarazel.de> <alpine.DEB.0.82.0810200022500.27788@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0810200022500.27788@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810200144.44383.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Monday 20 October 2008 01:25:22 Dave Airlie wrote:
> What type of laptop is it and what GPU has it.
> if distros are carrying GM45 supporting stuff we might be in trouble..
Its a Thinkpad T500 with a hybrid ATI/intel card, but the ATI card is disabled 
in bios (Intel card is not recognized properly if its enabled, havent started 
trying to track this down).
Vendor classifies the intel card as GMA 4500 MHD, and X says:
(II) intel(0): Integrated Graphics Chipset: Intel(R) Mobile Intel® GM45 
Express 
(--) intel(0): Chipset: "Mobile Intel® GM45 Express Chipset"

Andres
