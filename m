Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYCST2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYCST2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYCSTZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:27 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61733 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYCSTZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:24 -0400
Date: Tue, 18 Mar 2008 15:41:36 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: compilation break
In-reply-to: <5d6222a80803180930v732405cao8b5465f3842df9b1@mail.gmail.com>
To: Glauber Costa <glommer@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <200803181541.36246.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <5d6222a80803180930v732405cao8b5465f3842df9b1@mail.gmail.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008 09:30:45 am Glauber Costa wrote:
> commit 513f484dfe5cbb53e73ef1729703e7030e799487 breaks compilation
> with X86_VISW.
> 
> I don't have enough knowledge of the subtles of those things, so I'm
> just reporting it.
> But my educated guess is that it shouldn't be static, and the answer
> to the question that goes in the end of the commit log is "yes" ;-)
> 


sent out one patch already...

YH
