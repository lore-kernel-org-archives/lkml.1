Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZIHSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZIHSU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZIHSUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:20:24 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:59618 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbZIHSUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:20:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net AFFB23FE3FE
Message-ID: <4AA6A066.6020504@arcor.de>
Date: Tue, 08 Sep 2009 21:20:22 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <4807377b0909081047kfad088j694bd2b806075c5f@mail.gmail.com>
In-Reply-To: <4807377b0909081047kfad088j694bd2b806075c5f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 08:47 PM, Jesse Brandeburg wrote:
>[...]
> Sorry I haven't tested BFS yet, but am interested to see if it helps
> interactivity when playing flash videos on my dual core laptop.

Interactivity: yes (Flash will not result in the rest of the system 
lagging).

Flash videos: they will still play as bad as before.  BFS has no way to 
fix broken code inside Flash :P
