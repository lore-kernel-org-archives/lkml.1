Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275Ab0AZHzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0AZHzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537Ab0AZHzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:55:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:45463 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0AZHzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:55:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: A Rojas <nqn1976list@gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Followup-To: gmane.linux.kernel
Date: Tue, 26 Jan 2010 08:51:03 +0100
Message-ID: <hjm6t6$6mf$1@ger.gmane.org>
References: <20100125104728.4935.A69D9226@jp.fujitsu.com> <op.u63v1pxzasvm2a@kedge> <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 9.red-81-43-142.staticip.rima-tde.net
User-Agent: KNode/4.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:


> 
> Hi all,
> 
> Strangely, all reproduce machine are x86_64 with Intel i915. but I don't
> have any solid evidence.

Hi,
 I have the same issue in i686 (intel i915 too)

