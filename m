Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYKHSKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYKHSKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYKHSJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:09:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41107 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKHSJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:09:57 -0500
Date: Sat, 8 Nov 2008 10:09:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>,
       p_gortmaker@yahoo.com
Subject: Re: mmotm 2008-11-06-13-44 uploaded (smc-ultra)
Message-Id: <20081108100911.e475ff0f.randy.dunlap@oracle.com>
In-Reply-To: <200811062144.mA6LiWj8004200@imap1.linux-foundation.org>
References: <200811062144.mA6LiWj8004200@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4915D5E8.028D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 13:44:32 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-06-13-44 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc3:


mmotm-2008-1106-1344/drivers/net/smc-ultra.c: In function 'ultra_probe1':
mmotm-2008-1106-1344/drivers/net/smc-ultra.c:254: error: 'mac' undeclared (first use in this function)

---
~Randy
