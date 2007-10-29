Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXJ2LUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXJ2LUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXJ2LUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:20:15 -0400
Received: from michael.checkpoint.com ([194.29.32.68]:38312 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXJ2LUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:20:14 -0400
Message-ID: <4725C1EB.10205@checkpoint.com>
Date: Mon, 29 Oct 2007 13:20:11 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux kernel memory and split on 64-bit machines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I am researching now about the Linux kernel memory on 64-bit (x86_64) 
machines. I am looking into answering the following questions:

1. Is there a user-kernel split on 64-bit memories? If so, how is it 
done? What is the size of each part?

2. Does kernel high memory exists on 64-bit machines?

3. How is it possible to detect in runtime the split and the size of the 
physical memory?


Thanks,


Yoav

