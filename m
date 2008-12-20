Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYLTGrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYLTGrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYLTGra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:47:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:39549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752206AbYLTGr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:47:29 -0500
X-Authenticated: #1060932
X-Provags-ID: V01U2FsdGVkX18XELVzKsQX+ON+Wo8zCEG2Cbi331IyzOKkEJ3EFC
	S0GDYg/sEt/cmI
Message-ID: <494C94D8.9040703@gmx.net>
Date: Sat, 20 Dec 2008 07:46:48 +0100
From: Daniel Pelzl <pelzl@gmx.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sdb2 wrong uuid
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

my new kernels dont boot anymore.
The newest kernel that boots is 2.6.24
I use debian and i have it from apt sources.
What comes is driver sd needs updating - please use bus_type methods
and then /dev/sdb2 not found
and then /dev/sdb2 has wrong uuid
What does he want to tell me?
Not found or wrong uuid?
But kernel 2.6.24 works with

