Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYGBVmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYGBVmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYGBVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:41:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45334 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYGBVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:41:58 -0400
Date: Wed, 02 Jul 2008 14:41:40 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200807022333.25275.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
Message-id: <1215034900.6054.204.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200806301509.09013.oliver@neukum.org>
 <1215031257.6054.201.camel@lenovo.local.net>
 <200807022333.25275.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 23:33 +0200, Oliver Neukum wrote:

> This is odd. Your device shows one interface with one endpoint bulk and
> bulk out respectively. Yet two ports are created. Odd.

OK. If you mean /dev/ttyUSB0 and /dev/ttyUSB1 are always both created
when the device is plugged in - yep. This is the case in the working
kernel too. From what I've seen in howtos and the like, this seems to be
the case for most such devices. Well, let me know what else you need
from me. :)
-- 
adamw

