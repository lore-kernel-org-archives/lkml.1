Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZHCPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZHCPRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZHCPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:17:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbZHCPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:17:31 -0400
Message-ID: <4A76FE43.4070708@zytor.com>
Date: Mon, 03 Aug 2009 08:12:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: sam@ravnborg.org, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] Add LZO compression support for initramfs and old-style
 initrd
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-5-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-6-git-send-email-albin.tonnerre@free-electrons.com>
In-Reply-To: <1249311501-23102-6-git-send-email-albin.tonnerre@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 07:58 AM, Albin Tonnerre wrote:
>  
> +config INITRAMFS_COMPRESSION_LZO
> +	bool "LZO"
> +	depends on RD_LZO
> +	help
> +	  Its compression ratio is the poorest among the four. The kernel
> +	  size is about about 10% bigger than gzip; however its speed
> +
>  endchoice

Truncated help text...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

