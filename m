Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYEHHgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYEHHgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYEHHgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:36:21 -0400
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:4756 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYEHHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:36:20 -0400
From: Fabio De Francesco <fabiomdf@alice.it>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is less than 896MB?
Date: Thu, 8 May 2008 09:48:17 +0200
User-Agent: KMail/1.9.9
References: <200804301702.06019.fabiomdf@alice.it> <481DCA14.9030302@keyaccess.nl>
In-Reply-To: <481DCA14.9030302@keyaccess.nl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805080948.19914.fabiomdf@alice.it>
X-OriginalArrivalTime: 08 May 2008 07:34:58.0453 (UTC) FILETIME=[047C1C50:01C8B0DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008 16:37:08 you wrote:
>On 30-04-08 17:02, Fabio De Francesco wrote:
>
>> I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with
>> vanilla kernel 2.6.24 + TuxOnIce patch-set compiled for x86_32bit
>> (CONFIG_X86_32=y), whose /proc/meminfo shows "LowTotal 794MB".
>> 
>> I've always known that, in this specific platform, Linux permanently maps
>> 896MB as "Low Memory" into its linear address space (as this last value
>> is the one /proc/meminfo shows in the other two x86_32bit computers I
>> own).
>
>Others have already answered as well so this just as by the way and just in 
>case... why are you running a 32-bit kernel on it?
>
>Rene.
>

Hello Rene,

It's only because when I got the box I had to make it run as soon as possible, sooner than I'd had time to investigate which possible benefits I would have had from running a 64bit distribution.

Further, since I had to install a Gentoo GNU/Linux distribution by "emerging" from a chroot(-ed) environment inside an Ubuntu 32bit one (it takes too long to explain why), I supposed I couldn't do that for installing a 64bit Gentoo. Still today I don't know whether or not I assumed that wrongly.

Today I would switch to a 64bit Gentoo but, first I don't know how to do that in a secure and fast way, second I still don't know if it is worth the job... 

Could you please summarize which benefits I would gain from that?

-- 

Best Regards,

fabio de francesco
metanix.org


