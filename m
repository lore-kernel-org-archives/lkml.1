Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYI2JIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYI2JIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYI2JIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:08:14 -0400
Received: from quechua.inka.de ([193.197.184.2]:34838 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYI2JIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:08:14 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Use CPUID to communicate with the hypervisor.
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <48E085B3.1080507@redhat.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1KkEji-0004iu-00@calista.eckenfels.net>
Date: Mon, 29 Sep 2008 11:08:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <48E085B3.1080507@redhat.com> you wrote:
> In theory it can, but it would be a bad idea.  cpuid is best used to 
> communicate cpu features; ACPI and DMI are (mostly) system features.

Besides that, nobody stops a Hypervisor to offer valid and usefull DMI and
ACPI tables in the first place. I dont see a need to tunnel those through
CPUID.

Gruss
Bernd
