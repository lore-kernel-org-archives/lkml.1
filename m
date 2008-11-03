Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbYKCWdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbYKCWdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYKCWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:33:14 -0500
Received: from outbound-mail-34.bluehost.com ([69.89.18.154]:45725 "HELO
	outbound-mail-34.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755646AbYKCWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:33:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qq5vkz7nO33ZL7Mb2kHhDWtSPRgwtf+9MwH923Wxu7gJ2T8K9v0KOk22nFSnvjYk+VJXbHsUXXqH317jChL+ToVNZVauH+btwolzQXA4DgvhZT8JY28wyZVk1NvizB2y;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 6/7] PCI: remove excess kernel-doc notation
Date: Mon, 3 Nov 2008 14:33:04 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
References: <20081029223512.401bd1e6.randy.dunlap@oracle.com>
In-Reply-To: <20081029223512.401bd1e6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031433.05214.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2008 10:35 pm Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix pci/rom.c kernel-doc function notation:
>
> Warning(drivers/pci/rom.c:110): Excess function parameter or struct member
> 'return' description in 'pci_map_rom' Warning(drivers/pci/rom.c:177):
> Excess function parameter or struct member 'return' description in
> 'pci_map_rom_copy'

Thanks Randy, applied.

Jesse
