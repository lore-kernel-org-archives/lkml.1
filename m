Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZLAQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZLAQWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZLAQWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:22:00 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:56605 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbZLAQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:21:59 -0500
Message-ID: <4B1541EE.9000305@nortel.com>
Date: Tue, 01 Dec 2009 10:18:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com>
In-Reply-To: <4B15416A.2060202@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2009 16:21:53.0586 (UTC) FILETIME=[64DB9120:01CA72A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I forgot to mention that this was on 2.6.27.  I haven't tried it on
current git.

Chris
