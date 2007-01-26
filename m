Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXAZUug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXAZUug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXAZUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:50:36 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXAZUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:50:35 -0500
Message-ID: <45BA6994.7060301@zytor.com>
Date: Fri, 26 Jan 2007 12:50:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Khai Doan <khai@genius.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to create a fixed length character/block device/file ?
References: <45BA6018.5040406@genius.com>
In-Reply-To: <45BA6018.5040406@genius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Come to think of it, you can just use "tail" as the application that 
reads the FIFO.

	-hpa

