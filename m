Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZLRI77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZLRI77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZLRI74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:59:56 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:52993 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZLRI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:59:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=tV_12IIDGRQA:10 a=HyomMtlXPvQ6jM_36cEA:9 a=TX1tbWP5rnJycB1AnFhwaYwEMB4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B2B4485.6000305@cfl.rr.com>
Date: Fri, 18 Dec 2009 03:59:49 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, markh@compro.net,
       fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain> <4B2ABDC8.6090104@knaff.lu>
In-Reply-To: <4B2ABDC8.6090104@knaff.lu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 06:24 PM, Alain Knaff wrote:

> 
> Now, I only need to find a machine locally to test this on. Or Mark: are
> you confident in doing this yourself?
> 

I'll give it a shot. Sounds easy enough. If I have problems, I'll yell.

Mark

