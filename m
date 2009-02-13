Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbZBMS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbZBMS6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760956AbZBMS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:57:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:33080 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760901AbZBMS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:57:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MPoKc4iFCqT+ImW3+X6ptrDk9Au4N1aj98ATttlLfgfQK76u8vKIcGDEMotD+Sc9KC
         rG1HV4evFSRxl7ee0N86kwpEdn6laHBNCe3yfwTOORvjcBzWqiut3w9yn63P0cLC2F9E
         uaCMIismfnS74Q3pxodgBeCmznHtjuOxk/71U=
MIME-Version: 1.0
In-Reply-To: <4995C157.9020102@goop.org>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu>
	 <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu>
	 <4995C157.9020102@goop.org>
Date: Sat, 14 Feb 2009 00:27:43 +0530
Message-ID: <3f9a31f40902131057x3cff4d88h8e859873da43f73f@mail.gmail.com>
Subject: Re: [PATCH] x86 headers: include linux/types.h
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 12:22 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Ingo Molnar wrote:
>>
>> From 56cefcea7c8769ffc04a5609e6ac849e36685468 Mon Sep 17 00:00:00 2001
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Fri, 13 Feb 2009 13:23:02 +0100
>> Subject: [PATCH] x86 headers: include linux/types.h
>>
>> To properly pick up types relied on by prototypes like 'bool'.
>>
>
> linux/types.h is not assembler-safe.
>

AFAIK -tip's linux/types.h is assembly safe ;-)

JSR
