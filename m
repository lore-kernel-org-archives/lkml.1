Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZADXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZADXWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZADXV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:21:57 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:60288 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZADXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:21:57 -0500
Message-ID: <49614491.7020903@knaff.lu>
Date: Mon, 05 Jan 2009 00:21:53 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: update8 [PATCH 2/5] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com>
In-Reply-To: <496142E4.8040308@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alain Knaff wrote:
>> What do you mean "parametrized by the arch Kconfig files"? Does this
>> mean that it would still be in the global files, but would be enabled by
>> some kind of switch or preprocessor macro in the arch dependant file? If
>> easily doable, this would IMHO be preferable.
>>
> 
> Yes, that's what I mean.  Basically it'd use a dependency of some sort.
>  It's not really clear to me right at the moment which is best, too.

Just whatever is easiest.

> Also attached another followon bug fix patch; again, you don't need to
> resubmit for this.
> 
> 	-hpa
> 
> 

Looks ok to me. Thanks,

Alain
