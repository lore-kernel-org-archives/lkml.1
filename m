Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZCJUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZCJUhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZCJUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:37:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZCJUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:37:04 -0400
Message-ID: <49B6CB84.8060404@kernel.org>
Date: Tue, 10 Mar 2009 13:20:20 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Absolute symbols in vmlinux_64.lds.S
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org>	<20090310053721.GA25977@uranus.ravnborg.org> <m1bpsa6i72.fsf@fess.ebiederm.org>
In-Reply-To: <m1bpsa6i72.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I have no complaint with that.  I believe the symbols are absolute
> simply because they were originally coded that way and the relocatable
> kernel work on x86_64 didn't need them to change.
> 

I have a vague memory of a bug in the x86-64 ld.

	-hpa

