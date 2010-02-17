Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0BQF7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:59:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46553 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0BQF7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:59:36 -0500
Message-ID: <4B7B848C.6030603@kernel.org>
Date: Tue, 16 Feb 2010 21:54:20 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: James Cloos <cloos@jhcloos.com>, Jean Delvare <khali@linux-fr.org>,
       lasse.collin@tukaani.org, Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk> <20100214102308.1d1d6fff@hyperion.delvare> <20100214094940.GB17999@1wt.eu> <m3wrye9od4.fsf@lugabout.jhcloos.org> <20100217054047.GF18216@1wt.eu>
In-Reply-To: <20100217054047.GF18216@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 09:40 PM, Willy Tarreau wrote:
> 
> This raises the point of the maturity of the tools BTW. GZ is mature,
> BZ2 has become mature over the years, XZ is very recent and may still
> be buggy at times. We'll only know that when people will complain that
> they cannot open one file from time to time.
> 

This isn't a huge problem.  Since it is generated content we can, if
necessary, run a robot over the archive and verify and regenerate files
that have problems.

	-hpa
