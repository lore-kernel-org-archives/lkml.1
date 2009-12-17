Return-Path: <linux-kernel-owner+w=401wt.eu-S1764600AbZLQMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764600AbZLQMIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764595AbZLQMIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:08:49 -0500
Received: from lo.gmane.org ([80.91.229.12]:55401 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764604AbZLQMIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:08:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lukasz Sokol <el.es.cr@gmail.com>
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
Date: Thu, 17 Dec 2009 12:08:21 +0000 (UTC)
Message-ID: <loom.20091217T130812-276@post.gmane.org>
References: <loom.20091217T122606-341@post.gmane.org>
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

Lukasz Sokol <el.es.cr <at> gmail.com> writes:

Sorry, didn't finish a sentence :
> 
> Also I think the firmware (BIOS) reports these only when the operation on the
> WIFI card has been done, i.e. when it successfully toggled it, because when
> pushing the button too often (too small gap between pushes)
> 
... then it only reports one scancode (0xe0 0xf3)

(but then that might be because of some polling interval issues and/or the fact
I was doing it from a virtual console under X).

> 
> Lukasz
> 
> 

Lukasz


