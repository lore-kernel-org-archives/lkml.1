Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZLNXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZLNXgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZLNXgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:36:21 -0500
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:56450 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753669AbZLNXgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:36:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH] xilinx_spi.c: use resource_size()
Date: Mon, 14 Dec 2009 18:36:20 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EAB5@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200EA93@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH] xilinx_spi.c: use resource_size()
Thread-Index: Acp9D5/ewc7ygpsUTvidw/lprgEYJAABm/7Q
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA93@mi8nycmail19.Mi8.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 23:36:18.0280 (UTC) FILETIME=[3BFEFE80:01CA7D16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 14, 2009 3:49 PM, H Hartley Sweeten wrote:
> Use resource_size().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Please ignore.  An update to this driver just got merged that
handles this.

Sorry for the noise,
Hartley
