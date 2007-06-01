Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbXFAHZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbXFAHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXFAHZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:25:50 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:52422 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXFAHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:25:49 -0400
Message-ID: <465FC9FD.7060202@alcatel-lucent.com>
Date: Fri, 01 Jun 2007 15:25:49 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to access kdb explicitly
References: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
In-Reply-To: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2007 07:24:55.0268 (UTC) FILETIME=[F3AEE240:01C7A41D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I want to access kdb explicitly. For example, I could recognize the 
special characters inside console driver. If the the special characters 
are detected , then drop to kdb immediately. However, I don't know what 
should I to do after the special characters received.

Thanks,
Gavin
