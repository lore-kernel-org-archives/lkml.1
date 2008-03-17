Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYCQPEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYCQPEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYCQPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:03:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10989 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYCQPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:03:39 -0400
Message-ID: <47DE8804.9010401@oracle.com>
Date: Mon, 17 Mar 2008 08:02:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
References: <20080314092523.147382820@de.ibm.com>	 <20080314093046.914555041@de.ibm.com>	 <20080314091402.fa409ac7.randy.dunlap@oracle.com> <1205747051.16137.21.camel@localhost>
In-Reply-To: <1205747051.16137.21.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Fri, 2008-03-14 at 09:14 -0700, Randy Dunlap wrote:
>> Linux kernel uses "/**" to indicate the beginning of kernel-doc
>> notation, so when the comment block is not kernel-doc, please don't
>> use that /** to begin the comment block.
>> (multiple occurrences of this)
> 
> True. This is done consistently wrong in the zcrypt driver. I would
> prefer to do a separate kernel-doc cleanup patch and leave this patch as
> it is. Ok ?

Sure.  Thanks.

-- 
~Randy
