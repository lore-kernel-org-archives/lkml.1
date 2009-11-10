Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbZKJWpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbZKJWpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbZKJWpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:45:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbZKJWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:45:09 -0500
Message-ID: <4AF9EB4A.1050601@zytor.com>
Date: Tue, 10 Nov 2009 14:38:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110222756.GF15159@caffeine.csclub.uwaterloo.ca> <4AF9E94D.5040601@zytor.com> <20091110223407.GN15157@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091110223407.GN15157@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:34 PM, Lennart Sorensen wrote:
> On Tue, Nov 10, 2009 at 02:29:33PM -0800, H. Peter Anvin wrote:
>> I don't believe we were talking about ARM.
> 
> True.  I do get the impression the ARM has higher trap overhead than x86.

Also, the x87 FPU is a very clunky beast that's slow to emulate (unlike
SSE).

	-hpa

