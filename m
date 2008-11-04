Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYKDMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYKDMX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYKDMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:23:21 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:47129 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKDMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:23:20 -0500
Message-ID: <49103E57.20107@hiramoto.org>
Date: Tue, 04 Nov 2008 13:21:43 +0100
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080929)
MIME-Version: 1.0
To: Imre Kaloz <kaloz@openwrt.org>
Cc: =?UTF-8?B?TWlndWVsIMOBbmdlbCDDgWx2YXJleg==?= 
	<gotzoncabanes@gmail.com>,
       khc@pm.waw.pl, kernel@wantstofly.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: IXP4XX Maintainer
References: <b0438a630811032237s1a859a46ic6ee423c670720c1@mail.gmail.com> <op.uj3ft2yq2s3iss@ecaz>
In-Reply-To: <op.uj3ft2yq2s3iss@ecaz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imre Kaloz wrote:
> On Tue, 04 Nov 2008 07:37:09 +0100, Miguel Ángel Álvarez
> <gotzoncabanes@gmail.com> wrote:
>
>> Sorry for the question, but... who is supposed to be the mainteiner
>> for IXP4XX cpus?
>>
>> Thanks
>>
>> Miguel Ángel Álvarez
>
> I was supposed to pick it up, just Real Life (tm) got in the way..
> I'll queue up my pending
> patches during this week, and submit them to the arm-kernel list.
>

A lot of the stuff in openwrt svn would be nice to see mainline :-)

I'm most interested in
https://svn.openwrt.org/openwrt/trunk/target/linux/ixp4xx/patches-2.6.27/2*-npe_driver*

I'm using these now on an IXP425 and IXP435 with good results.
--
karl


svn

