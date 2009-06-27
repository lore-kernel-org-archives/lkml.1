Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZF0Sz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZF0Sz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 14:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZF0SzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 14:55:21 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:46195 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZF0SzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 14:55:20 -0400
Date: Sat, 27 Jun 2009 12:55:22 -0600
From: Alex Chiang <achiang@hp.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       linux-kernel@vger.kernel.org,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [2.6.31-rc1] oops in acpi_get_pci_dev
Message-ID: <20090627185522.GA24569@ldl.fc.hp.com>
References: <5a4c581d0906250325q1dd9ca67na9a8c7ecbffe4897@mail.gmail.com> <20090624150217.GD1512@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624150217.GD1512@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz>:
> 
> I had similar oops here, too, on thinkpad x60. It is interesting: most
> breakage seems to happen just before -rc1...

Already fixed in Linus's tree.

Thanks.

/ac
