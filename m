Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYDVUOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYDVUOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYDVUNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:13:55 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:52823 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYDVUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:13:54 -0400
Message-ID: <480E46FC.9030003@keyaccess.nl>
Date: Tue, 22 Apr 2008 22:13:48 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: config file part of kernel!
References: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com> <alpine.LNX.1.10.0804222103240.13697@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804222103240.13697@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-04-08 21:03, Jan Engelhardt wrote:

> On Tuesday 2008-04-22 18:53, Sanjeev Aditya Naga wrote:
>> Will it be good, if we make the `config` file (used to
>> build a kernel) part of the built kernel. So that one in
>> need, can extract it from the kernel using some
>> userspace tool!?
> 
> Surprise, what do you think /proc/config.gz is for? :-)

Now that you mention it -- why does the kernel export that thing gzipped in 
fact? It has a zlib copy...

Rene.
