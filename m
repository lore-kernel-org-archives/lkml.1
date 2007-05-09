Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbXEIXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbXEIXWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbXEIXWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:22:25 -0400
Received: from main.gmane.org ([80.91.229.2]:47238 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbXEIXWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:22:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: What tools to use?
Date: Wed, 09 May 2007 19:22:01 -0400
Message-ID: <46425799.1020809@gmail.com>
References: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: c-68-60-176-179.hsd1.mi.comcast.net
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shahbaz Khan wrote:
> All the experts on this list plz let me know of any good cross
> referencing tool for source code navigation. I have tried LXR but its
> not easy to configure for a rookie like me. Anyother as good as LXR?
> 
> Thank you.

http://opensolaris.org/os/project/opengrok/ - Works well if you don't 
mind the need for Java application server to run it. It is relatively 
easy to setup.

There is an blog article on setting it up for use with Linux kernel - 
http://uadmin.blogspot.com/2005/12/opengrok-zfs-linux-2612.html .

HTH
Parag

