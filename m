Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbZKFXFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbZKFXFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZKFXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:05:14 -0500
Received: from khc.piap.pl ([195.187.100.11]:46447 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZKFXFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:05:13 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Martin Schleier" <drahemmaps@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>
	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>
	<20091106200620.179910@gmx.net>
Date: Sat, 07 Nov 2009 00:05:12 +0100
In-Reply-To: <20091106200620.179910@gmx.net> (Martin Schleier's message of
	"Fri, 06 Nov 2009 21:06:20 +0100")
Message-ID: <m3r5sbcl07.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin Schleier" <drahemmaps@gmx.net> writes:

> e.g:
>  - correct use of some blackfin hi/lo macros.
>  - if certain data structures are declared as const
>    (struct seq_operations/file_operations)
>  - correct use of NR_CPUS is usually wrong
>  - complains about in_atomic() outside core kernel code
>  - warns about LINUX_VERSION_CODE, #if 0,
>    volatile or deprecated functions.
>  - informs about needless kfree/usb_free_urb checks
>  - etc...

Did the patch in question contain such problems?
-- 
Krzysztof Halasa
