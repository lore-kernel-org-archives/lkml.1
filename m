Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbZE2N4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbZE2N4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbZE2N4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:56:38 -0400
Received: from static-ip-85-25-59-232.inaddr.intergenia.de ([85.25.59.232]:34033
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbZE2N4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:56:37 -0400
X-Greylist: delayed 2875 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 09:56:37 EDT
Date: Fri, 29 May 2009 15:08:38 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <607840029.20090529150838@eikelenboom.it>
To: linux-kernel@vger.kernel.org
Subject: Re: Xen is a feature
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the feeling part of the problem is that the changes needed by Xen
for X86 are:
- a bit on the intrusive side compared to other patches to be in X86
- but too little to make it an arch on it's own (resulting in a lot of code
duplication.

I think it's some kind of special-case / sub-arch within X86, with which
the development of the kernel hasn't been confronted yet.

I must also add i'm looking forward to inclusion in mainline, and that KVM at the
moment isn't a real alternative to Xen for me.


Regards,

Samder

