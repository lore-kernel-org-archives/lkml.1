Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZJLIqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZJLIqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZJLIqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:46:01 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35985 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZJLIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:46:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] generic_nvram: Turn nvram_ioctl into an unlocked ioctl
Date: Mon, 12 Oct 2009 10:45:05 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       "Sven-Thorsten Dietrich" <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200910112131.40608.arnd@arndb.de> <200910120025.05208.arnd@arndb.de> <20091011224035.GB8146@nowhere>
In-Reply-To: <20091011224035.GB8146@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910121045.05708.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frederic Weisbecker wrote:
> Sorry, didn't know about that. I'm then taking Arnd Bergmann <arnd@arndb.de>
> found in the MAINTAINER file for the v2 patch.

Sure, there's no way you could have known about this. Vger started rejecting
mail from my usual MTA last week, so until I've found a solution for that
I have to use another MTA, but I didn't realize that gmail rewrites the
From: headers...

	Arnd <><
