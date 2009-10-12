Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbZJLXqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbZJLXqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZJLXqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:46:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZJLXqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:46:03 -0400
Message-ID: <4AD3BF8F.80709@zytor.com>
Date: Mon, 12 Oct 2009 16:45:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: lkml@makubi.at
CC: arndbergmann@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net> <4AD3B1A6.10508@zytor.com> <20091013005346.95254r0nd1pw97s4@www.kundendienste.net>
In-Reply-To: <20091013005346.95254r0nd1pw97s4@www.kundendienste.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 03:53 PM, lkml@makubi.at wrote:
> 
> So iptables uses the in-kernel IP stack and because of that fact, it  
> is not able to filter the DHCP packets?
> 

iptables is part of the in-kernel IP stack, yes...

	-hpa
