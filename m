Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXA2RDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXA2RDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXA2RDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:03:01 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13640 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXA2RDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:03:01 -0500
Date: Mon, 29 Jan 2007 08:58:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: vger truncating CC lists
Message-Id: <20070129085817.357c99bd.randy.dunlap@oracle.com>
In-Reply-To: <45BE18C9.6080200@cfl.rr.com>
References: <45BE18C9.6080200@cfl.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 10:54:49 -0500 Phillip Susi wrote:

> I have noticed that vger seems to be truncating Cc lists lately, often 
> resulting in broken partial email addresses in the Cc list causing 
> people that reply to have copies of the message bounced back instead of 
> being delivered to the intended recipients.  It seems that it munges 
> long, multi line Cc headers into one line, and truncates that line to a 
> maximum length.  Who is the list admin again?  And can they look into this?


http://vger.kernel.org/ says:
  Email questions: <postmaster@vger.kernel.org>


---
~Randy
