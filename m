Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHZLSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHZLSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYHZLSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:18:01 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:38084 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYHZLSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:18:00 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Tue, 26 Aug 2008 14:16:32 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080826095126.GA2609@ff.dom.local> <20080826110746.GC2609@ff.dom.local> <20080826111545.GD2609@ff.dom.local>
In-Reply-To: <20080826111545.GD2609@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261416.32315.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Jarek Poplawski wrote:
> Hmm.. it isn't actually answer to your question, sorry. As I said
> before I think we need to have more people interested in using such
> additional options, and btw. I understood from your message that
> disabling htb didn't solve the problem?
>
> Jarek P.
Only HTB - no. If i disable softlockup debug - seems the load is less (i must 
make sure), and if i remove HTB - it is becoming low. I will try to give 
exact numbers in recent days.

