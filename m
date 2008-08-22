Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYHVGmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYHVGmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYHVGmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:42:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYHVGmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:42:35 -0400
Message-ID: <48AE5FCF.6030103@zytor.com>
Date: Thu, 21 Aug 2008 23:42:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com>
In-Reply-To: <48ADDF4F.2020401@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>>
>>  Does this look like a kernel bug?
>>
> 
> No, it looks like a very common virtualizer bug.  Does the attached 
> patch work for you?
> 

Also, in addition to this, please try tip:master.  There is a patch in 
tip:master which I hope should fix this problem, but the details are 
important.

	-hpa
