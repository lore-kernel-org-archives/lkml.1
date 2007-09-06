Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbXIFKgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbXIFKgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXIFKgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:36:25 -0400
Received: from gw.goop.org ([64.81.55.164]:34108 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXIFKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:36:25 -0400
Message-ID: <46DFD825.2020109@goop.org>
Date: Thu, 06 Sep 2007 11:36:21 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] Add ELF note with Linux version
References: <20070904150018.GA4357@suse.de>
In-Reply-To: <20070904150018.GA4357@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> This patch adds version information to the ELF kernel file. Together
> with the bzImage version information, this allows distributions to
> identify the kernel version based on the file name.
>   

Seems reasonable to me, but I think the macro could be just called
"ELFNOTE".

    J
