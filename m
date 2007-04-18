Return-Path: <linux-kernel-owner+w=401wt.eu-S2992987AbXDRX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992987AbXDRX2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992991AbXDRX2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:28:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992987AbXDRX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:28:53 -0400
Message-ID: <4626A9AE.7080905@redhat.com>
Date: Wed, 18 Apr 2007 19:28:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Upgraded to 2.6.20.7 - positives
References: <200704190114.05885.vda.linux@googlemail.com>
In-Reply-To: <200704190114.05885.vda.linux@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> * From make menuconfig questions it looks like SATA/PATA
>   rewrite (in the form of libata) is almost finished. Hehe,
>   untangling IDE mess was quite a feat, and Jeff did it. Kudos.
> 

ADMA mode on nvidia chipsets still seems broken despite massive
amount of SATA fixes backported from 2.6.21...

