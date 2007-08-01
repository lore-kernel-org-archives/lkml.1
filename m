Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbXHAFzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbXHAFzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 01:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXHAFzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 01:55:09 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:4010 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbXHAFzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 01:55:08 -0400
Date: Wed, 1 Aug 2007 07:58:45 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: eurotechwdt will cause reboot
Message-ID: <20070801055845.GA2648@infomag.infomag.iguana.be>
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> config eurotechwdt to yes will cause system silent reboot. Is it right
> behaviour or a bug?

I think this might be a bug. I'll look at the code and will ask you to do some
tests for me (if that is ok for you).

Greetings,
Wim.
