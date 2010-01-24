Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938Ab0AXUum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0AXUum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 15:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803Ab0AXUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 15:50:41 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43920 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0AXUuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 15:50:40 -0500
Message-ID: <4B5CB29A.9010804@linux.vnet.ibm.com>
Date: Mon, 25 Jan 2010 02:20:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/memcontrol.c: fix "integer as NULL pointer" warning.
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com> <1264349038-1766-4-git-send-email-tfransosi@gmail.com>
In-Reply-To: <1264349038-1766-4-git-send-email-tfransosi@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010 09:33 PM, Thiago Farina wrote:
> mm/memcontrol.c:2548:32: warning: Using plain integer as NULL pointer

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
Three Cheers,
Balbir Singh
