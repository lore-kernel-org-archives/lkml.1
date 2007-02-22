Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781AbXBVTNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbXBVTNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXBVTNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:13:53 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXBVTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:13:52 -0500
Message-ID: <45DDEB10.6020200@zytor.com>
Date: Thu, 22 Feb 2007 11:12:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de> <45DDC810.3000401@zytor.com> <45DDD538.1040309@goop.org> <20070222183628.GA65601@muc.de> <Pine.LNX.4.61.0702221955200.7553@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702221955200.7553@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 22 2007 19:36, Andi Kleen wrote:
>> BTW would it make sense to have a special announcement list for such changes?
> 
> A changelog in the kernel tree would be helpful. A real changelog that is,
> not that info blob located at /Documentation/Changes.
> 

I presume you're talking about a BSD-style ChangeLog.  I've always found 
those utterly useless, since they're basically the equivalent of SCM 
history but without any of the abilities to sort, filter, etc, thus 
making it utterly impossible to find anything.  They're a pain to 
maintain (they inherently *always* cause merge failures) and add very 
little.

	-hpa
