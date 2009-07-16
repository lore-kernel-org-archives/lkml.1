Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbZGPUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbZGPUVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbZGPUVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:21:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58424 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbZGPUVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:21:23 -0400
Message-ID: <4A5F8B5C.3020902@garzik.org>
Date: Thu, 16 Jul 2009 16:19:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org> <4A5EA598.5050801@garzik.org> <7v3a8xb0lz.fsf@alter.siamese.dyndns.org> <4A5ECC09.3010405@garzik.org> <7vocrl9kwi.fsf@alter.siamese.dyndns.org> <4A5ED38F.5070708@garzik.org> <7v4otd9jg8.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7v4otd9jg8.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> That direction doesn't work due to firewalls, hence the scp out /to/
>> remote.example.com.
> 
> Ah, then the "git init --bare" at remote followed by pushing -all into it,
> suggested in your other subthread, would be an appropriate way.

Thanks!

	Jeff



