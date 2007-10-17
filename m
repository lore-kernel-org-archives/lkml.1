Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXJQWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXJQWQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXJQWQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:16:35 -0400
Received: from palrel10.hp.com ([156.153.255.245]:40974 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXJQWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:16:33 -0400
Message-ID: <471689BF.2040909@hp.com>
Date: Wed, 17 Oct 2007 15:16:31 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com> <20071017220019.GA22765@codeblau.de>
In-Reply-To: <20071017220019.GA22765@codeblau.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the packet trace was a bit too cooked perhaps, but there were indications that 
at times the TCP window was going to zero - perhaps something with window 
updates or persist timers?

rick jones
