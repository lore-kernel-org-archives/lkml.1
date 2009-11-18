Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZKRMCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZKRMCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZKRMCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:02:04 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46777 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZKRMCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rEow/mpp06YxyCjbYZGb/bpmn6KNK1jGngsGvibQLmhIs960YP7QeI8snqJJP/Y/jW
         sXFPXPxsKO/+hzyKHYqG6Zobnv1ExNr4VLiBdW+ihpoKMKkBCw68nyA6e6/7RWzY7cvU
         mh3IEK+thkhsXiiuonXY4pXK7gRYQCnlODtlM=
Message-ID: <4B03E23E.6090403@gmail.com>
Date: Wed, 18 Nov 2009 13:02:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091117 SUSE/3.0.0-2.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coverity checking periodicity?
References: <4B02601C.8000306@gmail.com> <alpine.LRH.2.00.0911181133360.31913@twin.jikos.cz> <4B03CE0C.3050604@gmail.com> <4B03DE53.2030607@gmail.com> <alpine.LSU.2.00.0911181252140.15039@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911181252140.15039@wotan.suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 12:52 PM, Jiri Kosina wrote:
>> 550 No such user (linux@coverity.com) (state 14).
> 
> Hmm, that used to be contact for linux kernel bugs as far as I remember 
> ... maybe they stopped caring for kernel bugs completely?

I don't know, but it definitely looks like they play dead.

Linux-2.6 is listed at:
http://scan.coverity.com/rung1.html

I used archive.org right now and the numbers haven't changed for years.
So maybe you're right in the end.

Thanks.
