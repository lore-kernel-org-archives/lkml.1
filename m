Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZHQUQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZHQUQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZHQUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:16:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33541 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZHQUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:16:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A89BA75.6040900@s5r6.in-berlin.de>
Date: Mon, 17 Aug 2009 22:15:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de> <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com> <4A899D41.7000405@s5r6.in-berlin.de> <4A89A7C0.1090909@gmail.com>
In-Reply-To: <4A89A7C0.1090909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> The problem im seeing is if I use ohci1394_dma=early on the bad kernel
> instantly Ill get a message on the screen saying:
> 
> PANIC: early exception 08 rip 246:10 error ffffffff8145ff15 cr2 0

Hmm, as I am not familiar with anything related to early initialization, 
I have no idea what it means let alone what causes it.
-- 
Stefan Richter
-=====-==--= =--- =---=
http://arcgraph.de/sr/
