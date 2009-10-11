Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZJKXza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZJKXza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZJKXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:55:29 -0400
Received: from nschwmtas04p.mx.bigpond.com ([61.9.189.146]:40892 "EHLO
	nschwmtas04p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbZJKXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:55:28 -0400
Message-ID: <4AD27044.7030907@bigpond.net.au>
Date: Mon, 12 Oct 2009 09:54:44 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pankaj Parakh <me.pankajparakh@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to add scheduler
References: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com> <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>
In-Reply-To: <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx01p.mx.bigpond.com from [121.222.41.232] using ID pwil3058@bigpond.net.au at Sun, 11 Oct 2009 23:54:45 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150203.4AD27045.00B9,ss=1,fgs=0
X-SIH-MSG-ID: oxwyEdH8TECznTh522DtQVUtlUy7/yU1v8pWRYIhuRsaTVjBu8PAR8u9caBD0e2jii4zZV6VP2AwYa/uWIvbttygI7xRU4o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/09 17:18, Pankaj Parakh wrote:
>   Hi all,
>
>   I want to add my scheduler in linux 2.6.25.3, which have modular
> design, is there any document which can explain that modular design of
> generic scheduler in detail. I wanted to try my scheduler.
>
> Any guidance..

Not really an answer to you question but related:  I'm resurrecting the 
CPU plug in scheduler project (to be renamed CPU_PISCH) which aims to 
provide an interface for people such as your self to implement CPU 
schedulers against and I was wondering if you were interested in adding 
your scheduler to this project?  Or taking part in other ways?

Thanks,
Peter
PS I'm currently working with respect to the latest kernel rather than 
2.6.25.3 (in case that's an issue).
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
