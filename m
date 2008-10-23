Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJWIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJWIxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYJWIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:53:13 -0400
Received: from main.gmane.org ([80.91.229.2]:43503 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYJWIxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:53:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: [PATCH 1/7] Adding empia base driver
Date: Thu, 23 Oct 2008 08:53:03 +0000 (UTC)
Message-ID: <loom.20081023T083620-961@post.gmane.org>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com> <20081022220903.GA15278@kroah.com> <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com> <20081022222727.GA17599@kroah.com> <d9def9db0810221535xbe8e5aegef8b09b81206ee92@mail.gmail.com> <20081022224943.GA22717@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.154.109.171 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg <at> kroah.com> writes:


> Please send patches that evolve the current drivers into supporting
> these new devices so that our development model is followed, and no user
> ends up in trouble.
> 
> thanks,
> 
> greg k-h
> 

(just my £.2, user's perspective warning)
Just to say this, the current in-tree driver doesn't support the device I own,
Markus' driver does.

Greg : 
The code Markus is requesting to merge is a completely NEW driver comparing to
the one that is in the tree (has a long and painful history). I think you might
safely assume that it already is NOT based on the old driver, tough shares the
name, due to the changes (and history).

Markus : just an idea - maybe if you've renamed the driver, to reflect the fact,
that it is completely new code, and schedule the old one to be deprecated ? 

Lukasz

