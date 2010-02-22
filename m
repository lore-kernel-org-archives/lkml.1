Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0BVQWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:22:38 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:24670 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0BVQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:22:36 -0500
Message-ID: <4B82AF18.3030107@oracle.com>
Date: Mon, 22 Feb 2010 08:21:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Subject: Re: linux-next: Tree for February 22 (media/video/tvp7002)
References: <20100222172218.4fd82a45.sfr@canb.auug.org.au>
In-Reply-To: <20100222172218.4fd82a45.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B82AF3D.01ED:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/10 22:22, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100219:


drivers/media/video/tvp7002.c:896: error: 'struct tvp7002' has no member named 'registers'


-- 
~Randy
