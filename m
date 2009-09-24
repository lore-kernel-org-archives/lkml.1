Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZIXR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZIXR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZIXR6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:58:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXR6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:58:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.31] NFS + suspend to ram hang...
Date: Thu, 24 Sep 2009 19:59:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <6278d2220909231545x217e1100k496bbdd44d0704de@mail.gmail.com>
In-Reply-To: <6278d2220909231545x217e1100k496bbdd44d0704de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909241959.39497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 September 2009, Daniel J Blueman wrote:
> Without the NFS4 homedir mount, suspend to ram works perfectly. With
> NFS4 homedir, suspend is started, but doesn't complete. Invoking
> kernel crashdump, all messages and backtrace looks entirely expected
> [1].
> 
> Anyone else find the same? Expected to work or not? What information
> would help with this?

Can you try this with 2.6.30?

Best,
Rafael
