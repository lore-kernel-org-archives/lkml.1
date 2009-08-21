Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbZHUUgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbZHUUgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbZHUUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:36:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbZHUUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:36:08 -0400
Message-ID: <4A8F0539.2000207@zytor.com>
Date: Fri, 21 Aug 2009 13:36:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tobias Doerffel <tobias.doerffel@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add specific support for Intel Atom architecture
References: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com>
In-Reply-To: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2009 04:11 PM, Tobias Doerffel wrote:
> This adds another option when selecting CPU family so the kernel can
> be optimized for Intel Atom CPUs. If GCC supports tuning options for
> Intel Atom they will be used.
> ---
>  arch/x86/Kconfig.cpu          |   17 +++++++++++++----
>  arch/x86/Makefile             |    2 ++
>  arch/x86/Makefile_32.cpu      |    2 ++
>  arch/x86/include/asm/module.h |    2 ++
>  4 files changed, 19 insertions(+), 4 deletions(-)

Tobias,

Please resend the patch with a Signed-off-by: line.

	-hpa
