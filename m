Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbZAOKk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbZAOKk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760625AbZAOKks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:40:48 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:56559 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760500AbZAOKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:40:47 -0500
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: deadlocks if use htb
Date: Thu, 15 Jan 2009 12:40:33 +0200
User-Agent: KMail/1.9.9
Cc: Badalian Vyacheslav <slavon@bigtelecom.ru>, Chris Caputo <ccaputo@alt.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20081010090426.GA6054@ff.dom.local> <200901151157.13340.denys@visp.net.lb> <20090115101015.GD5461@ff.dom.local>
In-Reply-To: <20090115101015.GD5461@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151240.33967.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are correct, on another hardware. Thats strange.

On Thursday 15 January 2009 12:10:15 Jarek Poplawski wrote:
>
> Denys, maybe I forgot something, but I think you reported this bug
> with nmi_watchdog too...
>
> Jarek P.


