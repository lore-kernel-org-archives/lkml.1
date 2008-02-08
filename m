Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbYBHTc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbYBHTc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbYBHTco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:32:44 -0500
Received: from mail.vyatta.com ([216.93.170.194]:50546 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbYBHTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:32:42 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.163
Date: Fri, 8 Feb 2008 11:32:36 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: KVM binary incompatiablity
Message-ID: <20080208113236.55b2ead1@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that recent KVM is incompatiable with older versions.

Using a KVM image created on 2.6.24 will crash on 2.6.25 (or
vice versa). It appears that Ubuntu Hardy has incorporated the 2.6.25
update even though it claims to be 2.6.24.

This is reproducible on Intel (64bit) kernel.  Was this intentional?
is it documented? 
