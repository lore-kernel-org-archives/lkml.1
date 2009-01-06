Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZAFB0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZAFB0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZAFB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:26:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55687 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZAFB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:26:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4962B327.1020209@s5r6.in-berlin.de>
Date: Tue, 06 Jan 2009 02:25:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
References: <fa.+H1UnEqOmFht/vMPmVy8ellbQi0@ifi.uio.no> <fa.RLz5WOGorLui5GRkc963Ww1kXqg@ifi.uio.no> <fa.x4ejZ7Kj7ZZRu88Sond1Cap6XxY@ifi.uio.no> <49628720.6050101@yahoo.com>
In-Reply-To: <49628720.6050101@yahoo.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> How about cheapseek? fastrandom? flash? ssd? However the internal flag
> is called QUEUE_FLAG_NONROT so it kind of makes sense just to leave it
> as nonrot...

It is not necessary to obfuscate an interface to userspace just because
some internally used cpp macro got an awkward name.
-- 
Stefan Richter
-=====-==--= ---= --==-
http://arcgraph.de/sr/
