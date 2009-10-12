Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZJLNNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZJLNNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZJLNNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:13:53 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:60302 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936AbZJLNNx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:13:53 -0400
From: Frans Pop <elendil@planet.nl>
To: "Toralf =?iso-8859-1?q?F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: build issue #26 for v2.6.32-rc4-1-gd93a8f8 :rivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
Date: Mon, 12 Oct 2009 15:13:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200910121411.09644.toralf.foerster@gmx.de>
In-reply-To: <200910121411.09644.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910121513.15572.elendil@planet.nl>
X-OriginalArrivalTime: 12 Oct 2009 13:13:15.0704 (UTC) FILETIME=[C2385380:01CA4B3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> the build (.config attached) failed, make ends with :
> ...
>   CC [M]  drivers/char/rtc.o
> drivers/char/rtc.c: In function 'rtc_interrupt':
> drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use
> in this function) 

This is already addressed in http://lkml.org/lkml/2009/10/12/74.

Cheers,
FJP
