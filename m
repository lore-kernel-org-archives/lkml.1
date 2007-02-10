Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXBJElE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXBJElE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 23:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXBJElE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 23:41:04 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:28116 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbXBJElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 23:41:01 -0500
Date: Fri, 09 Feb 2007 22:40:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
In-reply-to: <45CBE30D.5030006@nvidia.com>
To: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: David Ford <firefighterblu3@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Message-id: <45CD4CDA.7050600@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45C6BCE5.90103@shaw.ca>
 <20070204213603.a5bce839.akpm@linux-foundation.org> <45C6C531.20508@shaw.ca>
 <20070204221741.63152cbe.akpm@linux-foundation.org>
 <523e55a00702081326j43de05e3hdd8cf35e946eae9@mail.gmail.com>
 <45CBE30D.5030006@nvidia.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ayaz Abdulla wrote:
> For all those who are having issues, please try out the attached patch.
> 
> Ayaz

Seems to solve the problem for me (not heavily tested, but certainly 
isn't totally dead as it was before).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

