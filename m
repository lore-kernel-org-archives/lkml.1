Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZL3Nzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZL3Nzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZL3Nzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:55:33 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:48311 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZL3Nzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:55:32 -0500
Message-ID: <4B3B5BD2.3030500@mandriva.org>
Date: Wed, 30 Dec 2009 15:55:30 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: BFS v0.313 CPU scheduler for 2.6.32
References: <7574305f0912300434q1bf23b32sf3fb2b6554d79c4c@mail.gmail.com>
In-Reply-To: <7574305f0912300434q1bf23b32sf3fb2b6554d79c4c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas skrev 30.12.2009 14:34:
> A stupid mismerge in __might_sleep meant that with the right config
> options dmesg would have been swamped with false warnings. This also
> was making BFS consume a lot of CPU under certain conditions in
> combination with preempt RCU.
>
> Thanks to Jayson R King for picking it up!
>
> There are no other changes in this version compared to 312
>
> full patch:
> http://ck.kolivas.org/patches/bfs/2.6.32-sched-bfs-313.patch
>
> incremental:
> http://ck.kolivas.org/patches/bfs/2.6.32-bfs312-313.patch
>
> I highly recommend BFS users upgrade.
>

Nice.

any timeline for a version for 2.6.33 series kernels ?

--
Thomas
