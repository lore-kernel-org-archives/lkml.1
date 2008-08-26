Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYHZLdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYHZLdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYHZLdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:33:37 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:46105 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYHZLdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:33:36 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Tue, 26 Aug 2008 14:32:08 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080826095126.GA2609@ff.dom.local> <200808261416.32315.denys@visp.net.lb> <20080826113213.GA5991@ff.dom.local>
In-Reply-To: <20080826113213.GA5991@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261432.08594.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Jarek Poplawski wrote:

> So maybe you could try again this htb patch for limiting
> qdisc_watchdog_schedule()?
>
> Jarek P.
Yes, and i am going to take snapshops from system load with different boot 
flags. It will take time but, cause it is major router.

