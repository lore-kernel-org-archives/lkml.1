Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYGOCAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYGOCAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYGOCAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:00:12 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:37649 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754062AbYGOCAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:00:11 -0400
Date: Mon, 14 Jul 2008 22:00:10 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080715020010.GA18099@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   I am seeing the same boot failure on a second generation
MacBook Pro with both the kernel-2.6.26-136 srpm built on
Fedora 9 as well as with a stock unpatched linux 2.6.26 build
using the .config from the fedora 9 build. The boot process always
hangs with the errors...

 pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
 pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO

Could someone else try booting 2.6.26 on a second generation MacBook Pro?
                             Jack
