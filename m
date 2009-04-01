Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZDALXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZDALXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZDALX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:23:28 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:13326 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753972AbZDALX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:23:27 -0400
Message-ID: <49D34E33.5060700@panasas.com>
Date: Wed, 01 Apr 2009 14:21:23 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com> <49D332A0.5080107@garzik.org>
In-Reply-To: <49D332A0.5080107@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 11:23:23.0830 (UTC) FILETIME=[4504AD60:01C9B2BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 12:23 PM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> If anyone wants to actually run this code and test it
>> then please start reading at:
>>     http://open-osd.org
>> You will need to checkout the out-of-tree git (below) for the user-mode utilities.
>> Also the exofs.txt file in patch 7/8 should help
> 
> 
> hum...  trying to play with this.  If you want exofs to go upstream, I 
> think you should have a release tarball containing the user-mode utils 
> posted somewhere.  Would make life a lot easier, both on early adopters 
> and also on distribution packagers.
> 
> 	Jeff

You are absolutely right, once 2.6.30 will be out there will not be a need
to compile Kernel modules.

About the binary package. I must admit I'm a total novice. What do I need to do?

One x86_32, one x86_64? What glibc, does it matter what distro I compile on?

I want to have a "make rpm" and "make deb" but I've never done that, I was hoping
someone more experienced would pick it up.

But you are right I have it on my schedule to work on the Wiki, installation and
init-scripts, right after this final push to mainline.

Sorry, for not having this already
Boaz

BTW:
  Source tar balls are available from the gitweb GUI by pressing on the
  "snapshot" link next to any commit. I should link to it from the WiKi

Best regards
Boaz
