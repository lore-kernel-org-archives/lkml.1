Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZHKOPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZHKOPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZHKOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:15:14 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:60396 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZHKOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:15:11 -0400
Message-ID: <4A817CEC.2010704@davidnewall.com>
Date: Tue, 11 Aug 2009 23:45:08 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tony Mantler <nicoya@ubb.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: case-duplicated filenames
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca> <4A80D5DF.3090402@davidnewall.com> <4A80D6D4.3080005@ubb.ca>
In-Reply-To: <4A80D6D4.3080005@ubb.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Mantler wrote:
> David Newall wrote:
>> There appears to be a line missing:
>>
>> find $DIRECTORY | sed 's/^\(.*\)/INSERT INTO filenames (name) VALUES
>> ("\1");/' >>$SQLFILE
>
> ?


Sorry.  I just now realised what it does.
