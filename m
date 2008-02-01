Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbYBAGKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbYBAGKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYBAGKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:10:18 -0500
Received: from stinky.trash.net ([213.144.137.162]:37831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYBAGKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:10:16 -0500
Message-ID: <47A2B7C1.7070505@trash.net>
Date: Fri, 01 Feb 2008 07:10:09 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
       jeff.chua.linux@gmail.com, linux-kernel@vger.kernel.org, ole@ans.pl,
       cups-bugs@easysw.com, netfilter-devel@vger.kernel.org
Subject: Re: cups slow on linux-2.6.24
References: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>	<47A21945.2050005@trash.net>	<47A26C12.9020801@davidnewall.com> <20080131.181209.193710785.davem@davemloft.net> <47A2B71A.4090203@davidnewall.com>
In-Reply-To: <47A2B71A.4090203@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> I'm not debating that checksums are wrong. The question was how and
> where? It's not as if there are any unreliable communication paths in a
> loopback interface, so it's surprising that they could be wrong. How? Where?
> 

As I said, loopback doesn't perform full checksum calculation.
Its simply an optimization, nothing to worry about ...

