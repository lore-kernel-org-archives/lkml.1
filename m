Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZBESCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZBESCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbZBESCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:02:01 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:57206 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760185AbZBESB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:01:59 -0500
Message-ID: <498B2983.6010506@f-seidel.de>
Date: Thu, 05 Feb 2009 19:01:39 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <20090205172859.GA20558@kroah.com> <498B2294.5010809@suse.de> <498B23A5.6090006@f-seidel.de> <20090205174959.GA29368@kroah.com>
In-Reply-To: <20090205174959.GA29368@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I think that any macro called "dbg" should set the level automatically,
> as that is the way that the other macros in the kernel with this name do
> things...

I fully agree. So i reworked the patch which makes it even more
fit to its $SUBJECT.

Thanks,
Frank
