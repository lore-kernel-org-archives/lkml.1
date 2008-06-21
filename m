Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYFUQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYFUQz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYFUQzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:55:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYFUQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:55:28 -0400
Message-ID: <485D31A5.80001@zytor.com>
Date: Sat, 21 Jun 2008 09:51:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
References: <485C2875.2050204@goop.org> <485C4B0E.2090704@zytor.com> <87bq1uyjgi.fsf@basil.nowhere.org>
In-Reply-To: <87bq1uyjgi.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> There is no reason we couldn't do syscall for 32-bit native, but the
>> only processor that would benefit would be K7, and that's far enough
> 
> K6 actually. K7 has sysenter AFAIK. The K6 syscall was also slightly different
> and would need special case code.

Sorry, yes, K6.  Even more historic.

	-hpa
