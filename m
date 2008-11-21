Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYKUR3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYKUR3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKUR3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:29:31 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:47762 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKUR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:29:31 -0500
Message-ID: <4926EFEC.3000907@nortel.com>
Date: Fri, 21 Nov 2008 11:29:16 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: ananth@in.ibm.com, Nikanth Karthikesan <knikanth@suse.de>,
       linux-kernel@vger.kernel.org, davem@davemloft.net, mhiramat@redhat.com,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
References: <200811211720.26394.knikanth@suse.de> <20081121133800.GA5244@in.ibm.com> <4926DC1B.1020809@linux.vnet.ibm.com>
In-Reply-To: <4926DC1B.1020809@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 17:29:18.0320 (UTC) FILETIME=[AECCBF00:01C94BFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

> Undoubtedly, but a good warning is the best way to keep people warned about
> running such code :) It is a useful thing to have and to run, but running it
> would take more guts than anything else.

There is significant demand for this sort of thing in the 
telecom/enterprise space, where they would like to apply kernel patches 
(especially security patches and bugfixes) with minimal downtime.

Chris
