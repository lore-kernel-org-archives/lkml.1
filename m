Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYEDOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYEDOgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYEDOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:36:23 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36075 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEDOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:36:22 -0400
Message-ID: <481DCA14.9030302@keyaccess.nl>
Date: Sun, 04 May 2008 16:37:08 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Fabio De Francesco <fabiomdf@alice.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is
 less than 896MB?
References: <200804301702.06019.fabiomdf@alice.it>
In-Reply-To: <200804301702.06019.fabiomdf@alice.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-04-08 17:02, Fabio De Francesco wrote:

> I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with
> vanilla kernel 2.6.24 + TuxOnIce patch-set compiled for x86_32bit
> (CONFIG_X86_32=y), whose /proc/meminfo shows "LowTotal 794MB".
> 
> I've always known that, in this specific platform, Linux permanently maps
> 896MB as "Low Memory" into its linear address space (as this last value
> is the one /proc/meminfo shows in the other two x86_32bit computers I
> own).

Others have already answered as well so this just as by the way and just in 
case... why are you running a 32-bit kernel on it?

Rene.
