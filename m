Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZEXOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZEXOm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZEXOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:42:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZEXOmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:42:49 -0400
Message-ID: <4A195CE8.304@redhat.com>
Date: Sun, 24 May 2009 17:42:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: 2.6.29.1 BUG: unable to handle kernel NULL pointer dereference
 at (null) -> Oops
References: <4A193C51.7090607@wpkg.org>
In-Reply-To: <4A193C51.7090607@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> This system is running as a kvm-85 guest.
>

This is a guest oops, right?

-- 
error compiling committee.c: too many arguments to function

