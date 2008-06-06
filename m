Return-Path: <linux-kernel-owner+w=401wt.eu-S1765156AbYFFQPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765156AbYFFQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764751AbYFFQNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:13:12 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:53479 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764747AbYFFQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:13:10 -0400
Message-ID: <48496215.6050001@opengridcomputing.com>
Date: Fri, 06 Jun 2008 11:13:09 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: max size allocated via dma_alloc_coherent()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml:

Is there any way for a kernel module to know at runtime what the maximum 
size that can be allocated via dma_alloc_coherent()?

Thanks,

Steve.
