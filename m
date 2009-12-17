Return-Path: <linux-kernel-owner+w=401wt.eu-S965128AbZLQPS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbZLQPS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965125AbZLQPSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:18:16 -0500
Received: from lo.gmane.org ([80.91.229.12]:55386 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965123AbZLQPSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:18:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lukasz Sokol <el.es.cr@gmail.com>
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
Date: Thu, 17 Dec 2009 15:17:51 +0000 (UTC)
Message-ID: <loom.20091217T161042-883@post.gmane.org>
References: <loom.20091217T122606-341@post.gmane.org> <20091217150709.GA6375@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.152.73.88 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59 <at> srcf.ucam.org> writes:

> > The Internet is almost 'flooded' with reports of this not working on various
> > distributions, that's why decided to go a level higher.
> 
> What do you mean by "not working"? You don't really explain what the 
> issue you're seeing is.
> 

Hello Matthew,

I define "not working" in this case by "it switches hardware on/off without the
software knowing". 

i.e. the rfkill does not know, and the 'problem' is only noticed when the wifi
disassociates (but Network Manager tries on to reconnect). On the other hand,
invoking /sbin/rfkill [un]block wifi blocks/unblocks wifi comfortably.



