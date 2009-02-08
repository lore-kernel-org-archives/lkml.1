Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZBHTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZBHTOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZBHTOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:14:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZBHTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:14:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miles Lane <miles.lane@gmail.com>
Subject: Re: 2.6.29-rc3-git3 -- Failure to resume two Sandisk USB flash drives attached to a Belkin USB Busport Mobile (F5U022).
Date: Sun, 8 Feb 2009 20:13:44 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
References: <a44ae5cd0902022058x629dc2a3o641193630b60393f@mail.gmail.com> <200902030941.57261.rjw@sisk.pl> <a44ae5cd0902030933s5c936f9ex165b278338520673@mail.gmail.com>
In-Reply-To: <a44ae5cd0902030933s5c936f9ex165b278338520673@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082013.44939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Miles Lane wrote:
> This does seem to be a regression.
> 
> I just checked with Ubuntu Jaunty running 2.6.28-6-generic.  The USB
> host and USB
> flash drives resume perfectly with this setup.  I tested having
> Nautilus windows open
> for both drives, suspending and resuming.  After resuming, I was able
> to work with
> the folders and files in those Nautilus windows.

Well, please test .29-rc4 when it's out and let me know if it works.

Thanks,
Rafael
