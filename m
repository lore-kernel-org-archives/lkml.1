Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZFHN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZFHN6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZFHN6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:58:06 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53427 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZFHN6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:58:05 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 15:58:49 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <20090608133215.GA15482@srcf.ucam.org> <20090608134647.GA14234@elte.hu>
In-Reply-To: <20090608134647.GA14234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906081558.49860.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 8. Juni 2009 15:46:47 schrieb Ingo Molnar:
> ( Providing a way to _override_ those defaults is of course natural,
>   via /sysfs, should the user express an interest in tweaking it, or
>   should the kernel get it so wrong that a distro wants to work it
>   around. But your argument seems to be "push configuration and
>   handling into user-space" which is really backwards. )

If we agree that the default shall be that the kernel doesn't switch
off features of the hardware for power saving by default, does this
make a practical difference to keeping the configuration in user space?

	Regards
		Oliver

