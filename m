Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYEIKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYEIKtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYEIKtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:49:08 -0400
Received: from main.gmane.org ([80.91.229.2]:44922 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYEIKtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:49:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: linux-next does not find root partition on PATA ICH5
Date: Fri, 09 May 2008 11:48:52 +0100
Message-ID: <g01a6k$209$1@ger.gmane.org>
References: <fvv4m2$mp1$1@ger.gmane.org> <48231DC8.50600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

> Check out the patch CC'd to you in another thread ("Re: [git patches]
> libata updates[...]")

After trying the patch again this morning I found I mangled it and it does
in fact solve the problem I was seeing. Thanks!

-- 
Sitsofe

