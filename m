Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYIWWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYIWWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYIWWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:23:31 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:45961 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYIWWXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:23:31 -0400
Message-ID: <48D96C60.6000104@knaff.lu>
Date: Wed, 24 Sep 2008 00:23:28 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu> <48D96013.1070507@zytor.com> <48D966E4.7080200@knaff.lu> <48D96B58.6080604@zytor.com>
In-Reply-To: <48D96B58.6080604@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> [Trimming Cc: list]
> 
> Alain Knaff wrote:
>> H. Peter Anvin wrote:
>>> I mean I'm using O= to build in a different object directory.
>>
>> Could you please post an example of such a command line?
> 
> mkdir o.junk
> make O=o.junk defconfig
> make O=o.junk
> 
>     -hpa

Thanks. That's interesting, especially when testing stuff for several
architectures.

Alain

