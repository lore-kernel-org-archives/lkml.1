Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbXK3S1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbXK3S1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbXK3S06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:26:58 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40762 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbXK3S04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:26:56 -0500
Message-ID: <475055EE.9060105@hp.com>
Date: Fri, 30 Nov 2007 10:26:54 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Holger Hoffstaette <holger@wizards.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice	regression?
References: <pan.2007.11.29.23.42.52.661624@wizards.de>	<474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de>
In-Reply-To: <pan.2007.11.30.09.20.24.737500@wizards.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could the corruption be seen in a tcpdump trace prior to transmission 
(ie taken on the sender) or was it only seen after the data passed out 
the NIC?

rick jones
