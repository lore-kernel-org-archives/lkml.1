Return-Path: <linux-kernel-owner+w=401wt.eu-S965753AbXILNck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbXILNck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbXILNcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:32:31 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33225 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbXILNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:32:31 -0400
Message-ID: <46E7EA62.5020604@davidnewall.com>
Date: Wed, 12 Sep 2007 23:02:18 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain> <46E7DEF8.50201@davidnewall.com> <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> if the goal is to simply put all of the basic boot-time kernel parms
> along with the module-specific ones into a single file, sorted in
> alphabetical order, then i contend that this is, in fact, "silly".
>   

Or even, "messy".  There's no doubt that it should be maintained with 
care; perhaps it would if the people who write the code for each 
parameter also update the documentation.
