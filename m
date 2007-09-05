Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbXIEH6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbXIEH6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbXIEH6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:58:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbXIEH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:58:41 -0400
Message-ID: <46DE6196.3050605@zytor.com>
Date: Wed, 05 Sep 2007 08:58:14 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anton Arapov <aarapov@redhat.com>
CC: James Pearson <james-p@moving-picture.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>	<200605242029.k4OKTn9C031700@terminus.zytor.com>	<447EF58C.6000605@moving-picture.com>	<52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>	<46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com> <h87in5sgal.fsf@pepelac.englab.brq.redhat.com>
In-Reply-To: <h87in5sgal.fsf@pepelac.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Arapov wrote:
>   Hey guys, the future of this patch is important for me. What do you think, has this patch any chances to be committed to upstream?
> 
> James Pearson <james-p@moving-picture.com> writes:
>> H. Peter Anvin wrote:
>> There isn't that much that is duplicated - and there are also bits of
>> the /proc/PID/mem code that are not needed in this case, so I'm not
>> really sure if it is worth doing.
>>
>> I did submit a patch a few months ago - see:
>>
>> <http://marc.info/?l=linux-kernel&m=117862109623007&w=2>
> 

Looks reasonable to me, except for the one overlong line.

	-hpa
