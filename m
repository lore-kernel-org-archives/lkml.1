Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZJYQnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZJYQnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZJYQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZJYQnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:43:07 -0400
Message-ID: <4AE48018.3080109@redhat.com>
Date: Sun, 25 Oct 2009 18:43:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH tip/x86/entry] Fix user return notifier build
References: <1256473485-23109-1-git-send-email-avi@redhat.com> <20091025163844.GF20391@elte.hu>
In-Reply-To: <20091025163844.GF20391@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2009 06:38 PM, Ingo Molnar wrote:
> I suspect you want to pull x86/entry into kvm.git? The base patch itself
> has not caused any trouble.
>    

Yup.

-- 
error compiling committee.c: too many arguments to function

