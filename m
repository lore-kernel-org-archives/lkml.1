Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524Ab0A0Az4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0A0Az4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947Ab0A0Azy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:55:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0A0Azx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:55:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sboyce@blueyonder.co.uk
Subject: Re: HDA Intel Audio hang on boot
Date: Wed, 27 Jan 2010 01:56:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc5-rjw; KDE/4.3.3; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <201001261922.35213.rjw@sisk.pl> <4B5F5777.8070701@blueyonder.co.uk>
In-Reply-To: <4B5F5777.8070701@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001270156.46217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Sid Boyce wrote:
> I forgot to mention 2.6.33-rc5 now boots successfully.

Does that mean the problem is fixed in 2.6.33-rc5 or you still need the
enable_msi=0 workaround?

Rafael
