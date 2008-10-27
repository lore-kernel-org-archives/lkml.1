Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbYJ0CJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbYJ0CJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 22:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYJ0CJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 22:09:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYJ0CJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 22:09:07 -0400
Message-ID: <4905229F.2090805@zytor.com>
Date: Sun, 26 Oct 2008 19:08:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Harvey Harrison <harvey.harrison@gmail.com>, johannes@sipsolutions.net,
       davem@davemloft.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv2] printk: add the %pM, %p4, %p6 format specifiers
References: <1224892008.3919.27.camel@johannes.berg> <49035AF0.6040700@anduras.de> <1225008096.3478.3.camel@johannes.berg> <20081026.010329.11475786.davem@davemloft.net> <1225009308.3478.22.camel@johannes.berg> <1225009822.3478.30.camel@johannes.berg> <1225047674.10060.10.camel@brick> <1225049591.3746.0.camel@johannes.berg> <1225049929.10060.11.camel@brick> <1225050015.3746.2.camel@johannes.berg> <1225060789.10060.13.camel@brick> <1225060789.10060.13.camel@brick> <1225067465.5672.1.camel@brick> <200810270221.08675.elendil@planet.nl>
In-Reply-To: <200810270221.08675.elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
>> + * - '4' For a 4-byte IPv4 address, it prints the address in the
>> + *       usual colon-separated hex notation

Since when are IPv4 addresses "usually" printed in colon-separated hex?

	-hpa
