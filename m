Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYIZTad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYIZTad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYIZTa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:30:26 -0400
Received: from 1wt.eu ([62.212.114.60]:4502 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYIZTaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:30:25 -0400
Date: Fri, 26 Sep 2008 21:30:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: jerry <jerry@softwell.com.tw>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel patch 2.4.36-7
Message-ID: <20080926193010.GH24654@1wt.eu>
References: <48DCADE3.8000009@softwell.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DCADE3.8000009@softwell.com.tw>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:39:47PM +0800, jerry wrote:
> Hi, Sir
> 
> I knew there is a patch 2.4.37-rc1, but is there any support for ICH10?
> I tested it failed for SATA on ICH10.

could you please post your .config and the output of lspci -vvn please ?
I'd like to check if the PCI ID is there or not. If not, I'll propose
you a patch to add it and I'll ask you to retest.

Thanks,
Willy

