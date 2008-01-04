Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYADAKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYADAKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYADAKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:10:05 -0500
Received: from main.gmane.org ([80.91.229.2]:60101 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYADAKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:10:02 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: kernel BUG at fs/buffer.c:1245!
Date: Fri, 4 Jan 2008 00:09:48 +0000 (UTC)
Message-ID: <loom.20080104T000619-239@post.gmane.org>
References: <2198383E1141814486F0B881B3260CF501D6B58D@daebe103.NOE.Nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.112.242.129 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9b2) Gecko/2007121120 Firefox/3.0b2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 <Jayakrishnan.Chathu <at> nokia.com> writes:

> 
> 
> Hi
> 
> I am running 2.6.23 kernel on i386. Sometimes during reboot or file read
> write
> I get this kernel crash. .config attached. 
> 
> kernel BUG at fs/buffer.c:1245!
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in: sfpacket(PF) e1000 adm1026 hwmon_vid noksf pld_drv
> CPU:    2
> EIP:    0060:[<c0186a86>]    Tainted: PF       VLI
                               ^^^^^^^^^^^   
Is this OOPS reproducible with a non-tainted kernel (Do not force load any
proprietary modules and try to reproduce it - if you do, please post a bug
report over at http://bugzilla.kernel.org.)

Thanks  

Parag

