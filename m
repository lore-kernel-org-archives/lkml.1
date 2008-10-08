Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYJHTVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYJHTVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYJHTU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:20:59 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:48332 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYJHTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:20:58 -0400
Date: Thu, 9 Oct 2008 00:50:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com, prasad@linux.vnet.ibm.com
Subject: [RFC Patch 0/9] Hardware Breakpoint interfaces - v2
Message-ID: <20081008192044.GA4510@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	I'm posting a new revision of the patches for using HW
Breakpoint registers (first version posted y'day:
http://lkml.org/lkml/2008/10/7/127).

This patch includes changes which were agreed upon, following the
comments from Alan Stern. The patches which are still marked as RFC
(pending much larger discussion and interest) is based on 2.6.27-rc9.

Thanks,
K.Prasad

