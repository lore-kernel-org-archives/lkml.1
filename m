Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJNWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJNWMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYJNWMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:12:21 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:35885 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYJNWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:12:20 -0400
Message-ID: <48F5193B.1010601@nortel.com>
Date: Tue, 14 Oct 2008 16:12:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kaz Kylheku <kkylheku@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
In-Reply-To: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2008 22:12:15.0186 (UTC) FILETIME=[EA1A6B20:01C92E49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku wrote:

> I have the following question. Suppose that some proprietary driver
> (otherwise completely clean, based only on non-GPL symbols)

The fact that it's not using GPL symbols does not actually mean that the 
driver is not a derivative work of the kernel (and thus subject to the GPL).

> Would it be okay to have a mechanism like this:

<snip>

You should probably talk to a lawyer specializing in IP law.

Chris
