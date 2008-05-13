Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYEMRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYEMRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYEMRnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:43:49 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:58295 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYEMRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:43:48 -0400
Message-ID: <4829D345.7020909@t-online.de>
Date: Tue, 13 May 2008 19:43:33 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
In-Reply-To: <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: G0QMxGZvQh9j5M-OVuz9yAe8pIX9lLXL2+Oj1Pi2qp1SUnaUv2zW0o4XfXl3r9BZqr
X-TOI-MSGID: ff22352a-5f46-4cd3-92dc-ca3bd8c70e2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Can you try to run "strace su someuser" instead?
> 

I tried, but its a Heisenbug: If I run it with strace (with or without
-f), then it doesn't get stuck.


Regards

Harri

