Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZEXRZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZEXRZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 13:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZEXRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 13:25:08 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:43695 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZEXRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 13:25:07 -0400
Message-ID: <4A1982F9.8010804@wpkg.org>
Date: Sun, 24 May 2009 19:25:13 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: 2.6.29.1 BUG: unable to handle kernel NULL pointer dereference
 at (null) -> Oops
References: <4A193C51.7090607@wpkg.org> <4A195CE8.304@redhat.com>
In-Reply-To: <4A195CE8.304@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Tomasz Chmielewski wrote:
>> This system is running as a kvm-85 guest.
>>
> 
> This is a guest oops, right?

Yes, that was a guest Oops.


-- 
Tomasz Chmielewski
http://wpkg.org

