Return-Path: <linux-kernel-owner+w=401wt.eu-S1031237AbXDJRaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031237AbXDJRaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031236AbXDJRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:30:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031213AbXDJRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:30:19 -0400
Message-ID: <461BC99F.7020604@zytor.com>
Date: Tue, 10 Apr 2007 10:30:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu>
In-Reply-To: <20070410171924.GA18314@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> On Tue, Apr 10, 2007 at 08:43:14AM -0700, H. Peter Anvin wrote:
> 
>> I don't see the point in dealing with one particular corner case,
> 
> I wouldn't really call CJK a *corner* case, just think of how many people
> use these writing systems.
> 
> Theoretically it's just one particular case, I agree. In practice, however,
> this case occurs relatively often compared to all the nontrivial cases a
> full-featured terminal should cope with.
> 

Really?  Why is CJK so much more fundamental than, say, Arabic?

	-hpa

