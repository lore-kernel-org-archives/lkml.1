Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbYKLGYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbYKLGYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKLGX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:23:57 -0500
Received: from eazy.amigager.de ([213.239.192.238]:45985 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYKLGX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:23:56 -0500
Date: Wed, 12 Nov 2008 07:24:01 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081112062401.GA9261@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Greg KH <greg@kroah.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <200811111516.09163.rjw@sisk.pl> <20081111181925.GA5036@dose.home.local> <200811120048.06647.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811120048.06647.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 00:48:06 +0100, Rafael J. Wysocki wrote:

[...]

> Is there any possibility to get some information about where exactly
> it hangs?

Any idea how to do this? I already tried pm_trace, and there isn't a
serial interface. The screen is black when it hangs.

Regards,
Tino
