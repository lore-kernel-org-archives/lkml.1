Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbYLOUzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYLOUzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYLOUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:55:05 -0500
Received: from main.gmane.org ([80.91.229.2]:60385 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbYLOUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:55:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: Perfomance governor is still changing frequency
Date: Mon, 15 Dec 2008 20:53:35 +0000 (UTC)
Message-ID: <gi6g4f$tfj$1@ger.gmane.org>
References: <c4e36d110812150515q1c4b2458wa61c79c5a85c624e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 85-127-249-120.dynamic.xdsl-line.inode.at
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm noticing strange behavior on my T61.
> 
> When I select performance governor  for my CPU I still get occasional
> drop on CPU frequency from 2.2.GHz to 800MHz.

afaict, it is a bios issue ... on my thinkpad t60, the bios can be 
configured to covern the clock speed ... there is `thermal mode' option, 
where you can choose something like `full performance' and a `thermal 
optimized' ... i don't remember the full option name, but it is somehow 
named this way ...
on my t60 the cpu was clocked down sometimes in order to keep the cpu 
temperature below 70̊  until i switched to `full performance' ...

hth, tim

-- 
tim@klingt.org
http://tim.klingt.org

The price an artist pays for doing what he wants is that he has to do
it.
  William S. Burroughs

