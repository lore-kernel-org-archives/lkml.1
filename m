Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZAIXql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZAIXql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZAIXqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:46:31 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:35085 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZAIXq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:46:29 -0500
Message-ID: <4967E1B3.7080707@oracle.com>
Date: Fri, 09 Jan 2009 15:45:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <lg@denx.de>
Subject: Re: mmotm 2009-01-09-12-12 uploaded (leds)
References: <200901092013.n09KDXg2011856@imap1.linux-foundation.org>
In-Reply-To: <200901092013.n09KDXg2011856@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4967E1B5.00E4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-09-12-12 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


mmotm-2009-0109-1212/drivers/leds/leds-dac124s085.c: In function 'dac124s085_probe':
mmotm-2009-0109-1212/drivers/leds/leds-dac124s085.c:90: error: 'struct led_classdev' has no member named 'max_brightness'



-- 
~Randy
