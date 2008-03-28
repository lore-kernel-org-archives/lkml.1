Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYC1SHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYC1SHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYC1SH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:07:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:30707 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYC1SH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OyTIYhFIXv8tckth9tQf3GXUvUo6V8aphTjjqKtH2SMLqtoQbGF5mVyqVKffsACKu4lt2RuziKefDU88soZvAxjTssPTDCgx2lYEA+Lx9+Dmfo1/39W4n2r50XHX813NWRMqareSzzMmOoAxzrnrO4uyq9CpRZ9KgFxszb7DzxI=
Message-ID: <47ED33D1.10906@gmail.com>
Date: Fri, 28 Mar 2008 19:07:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
References: <47ECD0CF.1020003@gmail.com>	<87y783jdjo.fsf@basil.nowhere.org>	<47ECD715.90507@gmail.com>	<20080328113803.GQ29105@one.firstfloor.org>	<47ECE318.1030809@gmail.com>	<20080328133537.GS29105@one.firstfloor.org>	<20080328142408.6c8dc198@gaivota>	<47ED2A46.1010407@gmail.com> <20080328144708.0ef1dad4@gaivota>
In-Reply-To: <20080328144708.0ef1dad4@gaivota>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2008 06:47 PM, Mauro Carvalho Chehab wrote:
> On Fri, 28 Mar 2008 18:26:30 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 03/28/2008 06:24 PM, Mauro Carvalho Chehab wrote:
>>> It seems that the problem you're suffering is specific to some driver.
>> It's pseudo vivi.c
> 
> Ok, I've added the handler for compat32. I didn't test with skype yet.

It works, thanks a lot!
