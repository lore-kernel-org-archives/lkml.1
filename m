Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYJZKzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYJZKzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYJZKzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:55:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYJZKzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:55:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for October 24 (ACPI)
Date: Sun, 26 Oct 2008 11:59:33 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <20081025171606.f492a353.randy.dunlap@oracle.com>
In-Reply-To: <20081025171606.f492a353.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261159.34620.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Randy Dunlap wrote:
> On Fri, 24 Oct 2008 17:19:32 +1100 Stephen Rothwell wrote:
> 
> 
> linux-next-20081024/drivers/acpi/sleep/main.c:505: error: 'acpi_target_sleep_state' undeclared (first use in this function)
> linux-next-20081024/drivers/acpi/sleep/main.c:576: error: 'acpi_target_sleep_state' undeclared (first use in this function)
> make[4]: *** [drivers/acpi/sleep/main.o] Error 1

Yeah, there's a fix in the Len's tree:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=92daa7b53b76984565dfdfda5d9c679884121fb2

but Linus hasn't pulled it yet.

Thanks,
Rafael
