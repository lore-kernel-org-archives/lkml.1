Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYCYGVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYCYGVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYCYGVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:21:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35184
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYCYGVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:21:30 -0400
Message-ID: <47E899E4.5010209@qumranet.com>
Date: Tue, 25 Mar 2008 08:21:24 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ioan Ionita <opslynx@gmail.com>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc5-git5 KVM memory not freed
References: <df47b87a0803200941q7cbee10ev5a57f7cb25406896@mail.gmail.com>	 <47E63161.90002@qumranet.com> <47E64B27.3060400@qumranet.com> <df47b87a0803241630u5475fb00l4c76fc709af31a7f@mail.gmail.com>
In-Reply-To: <df47b87a0803241630u5475fb00l4c76fc709af31a7f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioan Ionita wrote:
> On Sun, Mar 23, 2008 at 2:20 PM, Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>  Attached patch ought to fix this.
>>     
>
> I confirmed! Regression is fixed. Thank you! 

Thanks for testing.

> Will it be pushed
> upstream for 2.6.25?
>   

Yes, of course.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

