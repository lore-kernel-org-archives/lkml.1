Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0BRQg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:36:59 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:23904 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0BRQg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:36:57 -0500
Message-ID: <4B7D6C5C.4010908@oracle.com>
Date: Thu, 18 Feb 2010 08:35:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for February 18 (media/video/gspca)
References: <20100218204937.54a613d2.sfr@canb.auug.org.au>
In-Reply-To: <20100218204937.54a613d2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B7D6C9E.017F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 01:49, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100217:


when CONFIG_INPUT is not enabled:

drivers/media/video/gspca/gspca.c:2345: error: 'struct gspca_dev' has no member named 'input_dev'
drivers/media/video/gspca/gspca.c:2347: error: 'struct gspca_dev' has no member named 'input_dev'


-- 
~Randy
