Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYBDMI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYBDMI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBDMIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:08:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbYBDMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:08:21 -0500
Date: Mon, 4 Feb 2008 04:08:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bugme-daemon@bugzilla.kernel.org, Greg KH <greg@kroah.com>,
       Shaohua Li <shaohua.li@intel.com>, plamen.petrov@tk.ru.acad.bg,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 9884] using the attached config hangs the kernel at boot
Message-Id: <20080204040801.9f445d10.akpm@linux-foundation.org>
In-Reply-To: <200802041304.20680.rjw@sisk.pl>
References: <20080204115803.450AF108018@picon.linux-foundation.org>
	<200802041304.20680.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 13:04:19 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Meanwhile, please set CONFIG_PCIEASPM.
> 
> Surely unset?

Yup.  I meant "please set CONFIG_PCIEASPM=n"
