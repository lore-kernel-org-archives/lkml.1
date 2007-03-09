Return-Path: <linux-kernel-owner+w=401wt.eu-S2993122AbXCIPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993122AbXCIPko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993121AbXCIPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:40:44 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43183 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993122AbXCIPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:40:43 -0500
Message-ID: <45F18016.4030502@cs.helsinki.fi>
Date: Fri, 09 Mar 2007 17:41:10 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
Subject: Re: [PATCH 7/7] revoke: wire up s390 system calls
References: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>	 <200703091611.09737.arnd@arndb.de> <1173454580.14888.1.camel@localhost>
In-Reply-To: <1173454580.14888.1.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Schwidefsky wrote:
> Yes, please put me or Heiko on CC if you add system calls to s390.

Ok, sorry about that. I would expect akpm to send it to you guys though 
whenever revoke graduates from -mm and not merge it to mainline.

				Pekka
