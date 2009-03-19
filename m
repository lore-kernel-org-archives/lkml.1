Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZCSQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZCSQww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZCSQwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:52:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:62229 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZCSQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:52:40 -0400
Message-ID: <49C278D8.5010809@oracle.com>
Date: Thu, 19 Mar 2009 09:54:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 19 (media/video/au0828)
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
In-Reply-To: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49C2784D.02BA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090318:


when ADV_DEBUG=n:


drivers/media/video/au0828/au0828-video.c:1438: error: 'const struct v4l2_subdev_core_ops' has no member named 'g_register'
drivers/media/video/au0828/au0828-video.c:1453: error: 'const struct v4l2_subdev_core_ops' has no member named 's_register'


-- 
~Randy
