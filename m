Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZHRBbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZHRBbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbZHRBbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:31:03 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16859 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZHRBbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:31:02 -0400
Message-ID: <4A8A0454.8000902@hp.com>
Date: Mon, 17 Aug 2009 18:31:00 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tim.bird@am.sony.com, r.schwebel@pengutronix.de, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       arjan@linux.intel.com, kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: new ipdelay= option for faster netboot
References: <20090814204305.GA31727@pengutronix.de>	<4A89AC40.2040109@am.sony.com> <4A89DB15.6060101@am.sony.com> <20090817.180323.253692704.davem@davemloft.net>
In-Reply-To: <20090817.180323.253692704.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I have card/switch combinations that take up to 10 seconds to
> negotiate a proper link.

Gotta love it when things adhere to specs...

rick jones
has also experienced nic/whatnot combinations that are far from IEEE specs... :(
